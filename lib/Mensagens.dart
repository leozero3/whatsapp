import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/model/Mensagem.dart';
import 'package:whatsapp/model/Usuario.dart';
import 'dart:io';

class Mensagens extends StatefulWidget {
  Usuario contato;

  Mensagens(this.contato);

  @override
  _MensagensState createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {

  final _picker = ImagePicker();
  String _idUsuarioLogado;
  String _idUsuarioDestinatario;
  FirebaseFirestore db = FirebaseFirestore.instance;
  bool _subindoImagem = false;
  TextEditingController _controllerMensagem = TextEditingController();

  _enviarMensagem() {
    String textoMensagem = _controllerMensagem.text;
    if (textoMensagem.isNotEmpty) {
      Mensagem mensagem = Mensagem();
      mensagem.idUsuario = _idUsuarioLogado;
      mensagem.mensagem = textoMensagem;
      mensagem.urlImagem = '';
      mensagem.tipo = 'texto';

      /// Salvar mensagem remetente
      _salvarMesagem(_idUsuarioLogado, _idUsuarioDestinatario, mensagem);

      /// Salvar mensagem destinatario
      _salvarMesagem(_idUsuarioDestinatario, _idUsuarioLogado, mensagem);
    }
  }

  _salvarMesagem(String idRemetente, String idDestinatario, Mensagem msg) async {
    await db.collection('mensagens').doc(idRemetente).collection(idDestinatario).add(msg.toMap());

    //Limpa caixa de texto
    _controllerMensagem.clear();
  }

  _enviarFoto() async {
    PickedFile imagemSelecionada;
    imagemSelecionada = (await _picker.getImage(source: ImageSource.gallery));

    String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();

    _subindoImagem = true;

    /// convert imagePicker em 'io'
    var file = File(imagemSelecionada.path);

    /// convert imagePicker em 'io'
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();
    Reference arquivo = pastaRaiz
        .child('mensagens')
        .child(_idUsuarioLogado)
        .child(nomeImagem + '.jpg');

    ///upload da imagem
    UploadTask task = arquivo.putFile(file);

    ///controlar progresso do upload

    task.snapshotEvents.listen((TaskSnapshot storageEvent) {
      if (storageEvent.state == TaskState.running) {
        setState(() {
          _subindoImagem = true;
        });
      } else if (storageEvent.state == TaskState.success) {
        _subindoImagem = false;
      }
    });

    ///Recuperar URL da imagem
    task.then((TaskSnapshot taskSnapshot) {
      _recuperarUrlImagem(taskSnapshot);
    });
  }

  Future _recuperarUrlImagem(TaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();

    Mensagem mensagem = Mensagem();
    mensagem.idUsuario = _idUsuarioLogado;
    mensagem.mensagem = '';
    mensagem.urlImagem = url;
    mensagem.tipo = 'imagem';

    /// Salvar mensagem remetente
    _salvarMesagem(_idUsuarioLogado, _idUsuarioDestinatario, mensagem);

    /// Salvar mensagem destinatario
    _salvarMesagem(_idUsuarioDestinatario, _idUsuarioLogado, mensagem);
  }

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = auth.currentUser;
    _idUsuarioLogado = usuarioLogado.uid;

    _idUsuarioDestinatario = widget.contato.idUsuario;
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    /// CAIXA DE MENSAGEM PARA DIGITAR E BOTAO ENVIAR ==========================
    var caixaMensagem = Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: TextFormField(
                controller: _controllerMensagem,
                autofocus: true,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                  hintText: 'Digite uma mensagem...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  prefixIcon:
                  _subindoImagem
                      ? CircularProgressIndicator()
                      : IconButton(icon: Icon(Icons.camera_alt),onPressed: _enviarFoto),
                ),
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: _enviarMensagem,
            backgroundColor: Color(0xff075E54),
            child: Icon(Icons.send, color: Colors.white),
            mini: true,
          )
        ],
      ),
    );

    /// TELA DE CONVERSA =======================================================
    var stream = StreamBuilder(
      stream: db
          .collection("mensagens")
          .doc(_idUsuarioLogado)
          .collection(_idUsuarioDestinatario)
          .snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: <Widget>[Text("Carregando mensagens"), CircularProgressIndicator()],
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            QuerySnapshot querySnapshot = snapshot.data;

            if (snapshot.hasError) {
              return Expanded(
                child: Text("Erro ao carregar os dados!"),
              );
            } else {
              return Expanded(
                child: ListView.builder(
                    itemCount: querySnapshot.docs.length,
                    itemBuilder: (context, indice) {
                      //recupera mensagem
                      List<DocumentSnapshot> mensagens = querySnapshot.docs.toList();
                      DocumentSnapshot item = mensagens[indice];

                      double larguraContainer = MediaQuery.of(context).size.width * 0.8;

                      //Define cores e alinhamentos
                      Alignment alinhamento = Alignment.centerRight;
                      Color cor = Color(0xffd2ffa5);
                      if (_idUsuarioLogado != item["idUsuario"]) {
                        alinhamento = Alignment.centerLeft;
                        cor = Colors.white;
                      }

                      return Align(
                        alignment: alinhamento,
                        child: Padding(
                          padding: EdgeInsets.all(6),
                          child: Container(
                            width: larguraContainer,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: cor, borderRadius: BorderRadius.all(Radius.circular(8))),
                            child: //Text(item["mensagem"], style: TextStyle(fontSize: 18),
                            item["tipo"] == "texto"
                                ? Text(item["mensagem"],style: TextStyle(fontSize: 18),)
                                : Image.network(item["urlImagem"]),
                          ),
                        ),
                      );
                    }),
              );
            }
            break;
        }
      },
    );

    /// CORPO DA PAGINA ========================================================
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            CircleAvatar(
                maxRadius: 20,
                backgroundColor: Colors.grey,
                backgroundImage: widget.contato.urlImagem != null
                    ? NetworkImage(widget.contato.urlImagem)
                    : null),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(widget.contato.nome),
            )
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/imagens/bg.png"), fit: BoxFit.cover)),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                stream,
                caixaMensagem,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
