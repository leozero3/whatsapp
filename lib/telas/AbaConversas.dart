import 'package:flutter/material.dart';
import 'package:whatsapp/model/Conversa.dart';

class AbaConversas extends StatefulWidget {
  @override
  _AbaConversasState createState() => _AbaConversasState();
}

class _AbaConversasState extends State<AbaConversas> {
  List<Conversa>_listaConversas = List();

  @override
  void initState() {
    super.initState();

    Conversa conversa = Conversa();
    conversa.nome = 'amanda';
    conversa.mensagem = 'olá mundo';
    conversa.caminhoFoto = 'https://firebasestorage.googleapis.com'
        '/v0/b/whatsapp-1d406.appspot.com/o/perfil%2Fperfil1.'
        'jpg?alt=media&token=6673ca3e-c247-4a76-b643-cf036f8f3d98';

    _listaConversas.add(conversa);

  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _listaConversas.length,
        itemBuilder: (context, indice) {

          Conversa conversa = _listaConversas[indice];

          return ListTile(
            contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            leading: CircleAvatar(
              maxRadius: 30,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(conversa.caminhoFoto),
            ),
            title: Text(
              conversa.nome,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              conversa.mensagem,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          );
        });
  }
}
