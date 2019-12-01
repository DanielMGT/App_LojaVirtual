import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BotaoPedido extends StatelessWidget {
  final String idPedido;

  BotaoPedido(this.idPedido);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance
                .collection("pedidos")
                .document(idPedido)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                int status = snapshot.data["status"];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      ""
                      "código do pedido: ${snapshot.data.documentID}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      _buildTextoProdutos(snapshot.data),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      "Status do pedido:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                        SizedBox(height: 4.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            _buildCirculo("1", "Preparação", status, 1),
                            _linha(),
                            _buildCirculo("2", "Transporte", status, 2),
                            _linha(),
                            _buildCirculo("3", "Entrega", status, 3),
                          ],
                        )
                      ],
                );
              }
            }),
      ),
    );
  }

  String _buildTextoProdutos(DocumentSnapshot snapshot){
    String text = "Descrição:\n";
    for(LinkedHashMap prod in snapshot.data["produtos"]){
        text += "${prod["qtd"]} x ${prod["product"]["title"]}"
            " (R\$ ${prod["product"]["price"].toStringAsFixed(2)})\n";
    }
    text += "Total: R\$ ${snapshot.data["precoTotal"].toStringAsFixed(2)}";
    return text;
  }

  Widget _buildCirculo(String titulo, String subtitulo, int status, int thisStatus){
      Color corFundo;
      Widget child;

      if(status < thisStatus){
        corFundo = Colors.grey[500];
        child = Text(titulo, style: TextStyle(
          color: Colors.white,
        )
        );
      }
      else if(status == thisStatus){
        corFundo = Colors.blue;
        child = Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Text(titulo, style:
              TextStyle(
                color: Colors.white,
              ),
            ),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          ],
        );
      }
      else {
        corFundo = Colors.green;
        child = Icon(
          Icons.check,
          color: Colors.white,
        );
      }
      return Column(
        children: <Widget>[
          CircleAvatar(
            radius: 20.0,
            backgroundColor: corFundo,
            child: child,
          ),
          Text(subtitulo),
        ],
      );
  }

  Widget _linha(){
    return Container(
      height: 1.0,
      width: 40.0,
      color: Colors.grey[500],
    );
  }

}
