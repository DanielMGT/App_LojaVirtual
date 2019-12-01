import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/Dados/DadosProduto.dart';
import 'package:loja_virtual/Dados/ProdCarrinho.dart';
import 'package:loja_virtual/models/CarrinhoModel.dart';


class CompraProdutos extends StatelessWidget {

  final ProdCarrinho cartProduct;


  CompraProdutos(this.cartProduct);


  @override
  Widget build(BuildContext context) {

    Widget _buildContent(){
      CarrinhoModel.of(context).atualizarPrecos();

      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            width: 120.0,
            child: Image.network(
              cartProduct.prodCarrinho.images[0],
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    cartProduct.prodCarrinho.title,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17.0),
                  ),
                  Text(
                    "R\$ ${cartProduct.prodCarrinho.price.toStringAsFixed(2)}",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove),
                        color: Theme.of(context).primaryColor,
                        onPressed: cartProduct.qtd > 1 ?
                            (){
                          CarrinhoModel.of(context).decProduct(cartProduct);
                        } : null,
                      ),
                      Text(cartProduct.qtd.toString()),
                      IconButton(
                        icon: Icon(Icons.add),
                        color: Theme.of(context).primaryColor,
                        onPressed: (){
                          CarrinhoModel.of(context).incProduct(cartProduct);
                        },
                      ),
                      FlatButton(
                        child: Text("Remover"),
                        textColor: Colors.grey[500],
                        onPressed: (){
                          CarrinhoModel.of(context).removerItemCarrinho(cartProduct);
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      );
    }



    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: cartProduct.prodCarrinho == null?
          FutureBuilder<DocumentSnapshot>(
            future: Firestore.instance.collection("produtos").document(cartProduct.category)
                .collection("itens").document(cartProduct.pId).get(),
            builder: (context, snapshot){
              if(snapshot.hasData){
                cartProduct.prodCarrinho = DadosProduto.fromDocument(snapshot.data);
                return _buildContent();
              }else{
                return Container(
                  height: 70.0,
                  child: CircularProgressIndicator(),
                  alignment: Alignment.center,
                );
              }
            },
          ):
      _buildContent(),
    );
  }
}
