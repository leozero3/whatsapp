import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/telas/AbaContatos.dart';
import 'package:whatsapp/telas/AbaConversas.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tabController;

  List<String> itensMenu = ['Configurações', 'Deslogar'];

  String _emailUser = '';

  Future _recuperarDadosUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User userLogado = await auth.currentUser;
    setState(() {
      _emailUser = userLogado.email;
    });
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUser();
    _tabController = TabController(length: 2, vsync: this);
  }

  _escolhaMenuItem(String itemEscolhido) {
    switch (itemEscolhido) {
      case 'Configurações':
        print('Configurações');
        break;
      case 'Deslogar':
        _deslogarUsuario();
        break;
    }
    //print('item: ' + itemEscolhido);
  }

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();

    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WhatsApp'),
        bottom: TabBar(
          indicatorWeight: 4,
          indicatorColor: Colors.white,
          labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          controller: _tabController,
          tabs: [
            Tab(
              text: 'Conversas',
            ),
            Tab(
              text: 'Contatos',
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context) {
              return itensMenu.map(
                (String item) {
                  return PopupMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                },
              ).toList();
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AbaConversas(),
          AbaContatos(),
        ],
      ),
    );
  }
}
