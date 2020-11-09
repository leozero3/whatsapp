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
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            AbaConversas(),
            AbaContatos(),
          ],
        ));
  }
}
