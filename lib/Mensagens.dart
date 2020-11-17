import 'package:flutter/material.dart';
import 'package:whatsapp/model/Usuario.dart';

class Mensagens extends StatefulWidget {
  Usuario contato;

  Mensagens(this.contato);

  @override
  _MensagensState createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {
  List<String> listaMensagens = [
    'Na caminhada da vida, ',
    'aprendi que nem sempre temos o que queremos. ',
    'Porque nem sempre o que queremos nos faz bem.',
    'Foi preciso sentir dor,',
    ' para queeu aprendesse com as lágrimas.',
    'Foi necessário o riso, para que eu não me enclausurasse com o tempo.',
    'E a vitória sem conquista é ilusão.',
    'E a maior virtude dos fortes é o perdão.',
  ];

  TextEditingController _controllerMensagem = TextEditingController();

  _enviarMensagem() {}

  _enviarFoto() {}

  @override
  Widget build(BuildContext context) {
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
                  prefixIcon: IconButton(icon: Icon(Icons.camera_alt), onPressed: _enviarFoto),
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

    var listView = Expanded(
      child: ListView.builder(
        itemCount: listaMensagens.length,
        itemBuilder: (context, indice) {

          double larguraContainer = MediaQuery.of(context).size.width * 0.8;

          Alignment alinhamento = Alignment.centerRight;
          Color cor = Color(0xffd2ffa5);
          if ( indice % 2  == 0){
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
                  color: cor,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Text(
                  listaMensagens[indice],
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),
          );
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(widget.contato.nome)),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imagens/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
            child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              listView,
              caixaMensagem,
            ],
          ),
        )),
      ),
    );
  }
}
