import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/BotaoDrawer/BotaoPedido.dart';
import 'package:loja_virtual/models/UserModel.dart';
import 'package:loja_virtual/screens/LoginScreen.dart';

class Pedidos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    if(UserModel.of(context).isLoggedIn()){
        String uid = UserModel.of(context).firebaseUser.uid;

        return FutureBuilder<QuerySnapshot>(
          future: Firestore.instance.collection("usuarios").document(uid).collection("pedidos").getDocuments(),
          builder: (context, snapshot){
            if(!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            else {
              return ListView(
                children: snapshot.data.documents.map(
                    (doc) => BotaoPedido(doc.documentID)).toList(),
                );
            }
          },
        );
    }
    else {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.add_shopping_cart, size: 32.0, color: Theme.of(context).primaryColor),
            Text("Precisa estar logado para adicionar/visualizar seus pedidos!", style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
            ),
            RaisedButton(
              child: Text("Entrar", style: TextStyle(
                color: Colors.white,
              ),
              ),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            )
          ],
        ),
      );
    }
  }
}
