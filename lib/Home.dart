import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

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
    _recuperarDadosUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WhatsApp'),
      ),
      body: Container(
        child: Text(_emailUser),
      ),
    );
  }
}

