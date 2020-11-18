import 'package:flutter/material.dart';
import 'package:whatsapp/model/Conversa.dart';

class AbaConversas extends StatefulWidget {
  @override
  _AbaConversasState createState() => _AbaConversasState();
}

class _AbaConversasState extends State<AbaConversas> {
  List<Conversa> listaConversas = [
    Conversa(
        'amanda',
        'olá mundo',
        'https://firebasestorage.googleapis.com/v0/b/whatsapp-1d406.appspot.com/o/perfil%2Fperfil1.'
            'jpg?alt=media&token=6673ca3e-c247-4a76-b643-cf036f8f3d98'),
    Conversa(
        'isaac',
        'hello',
        'https://firebasestorage.googleapis.com/v0/b/whatsapp-1d406.appspot.com/o/perfil%2Fperfil2.'
            'jpg?alt=media&token=b1536f4d-cc3b-41f1-9465-050f398c1196'),
    Conversa(
        'kris',
        'olá, tudo bem',
        'https://firebasestorage.googleapis.com/v0/b/whatsapp-1d406.appspot.com/o/perfil%2Fperfil3.'
            'jpg?alt=media&token=04ced82c-f072-46a0-bffc-497ac85cf0bd'),
    Conversa(
        'diogo',
        'como vai voce',
        'https://firebasestorage.googleapis.com/v0/b/whatsapp-1d406.appspot.com/o/perfil%2Fperfil4.'
            'jpg?alt=media&token=99d57386-eed2-4bcc-8e40-2e5327066c0f'),
    Conversa(
        'jamiltom',
        'até amanha',
        'https://firebasestorage.googleapis.com/v0/b/whatsapp-1d406.appspot.com/o/perfil%2Fperfil5.'
            'jpg?alt=media&token=9910ce8c-ff55-4ece-b278-e962dfed0073')
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: listaConversas.length,
        itemBuilder: (context, indice) {

          Conversa conversa = listaConversas[indice];

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
