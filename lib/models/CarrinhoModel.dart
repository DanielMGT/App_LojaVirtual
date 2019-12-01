import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/Dados/ProdCarrinho.dart';
import 'package:loja_virtual/models/UserModel.dart';
import 'package:scoped_model/scoped_model.dart';

class CarrinhoModel extends Model{
  List <ProdCarrinho> products = [];

  UserModel user;
  String cupomCode;
  int desconto = 0;

  CarrinhoModel(this.user){
    if(user.isLoggedIn()) {
      _carregarItensCarrinho();
    }
  }

  bool isLoading = false;

  static CarrinhoModel of(BuildContext context) =>
      ScopedModel.of<CarrinhoModel>(context);

  void addProd(ProdCarrinho prodCarrinho){
    products.add(prodCarrinho);
    
    Firestore.instance.collection("usuarios").document(user.firebaseUser.uid)
        .collection("carrinho").add(prodCarrinho.toMap()).then((doc){
          prodCarrinho.id = doc.documentID;
    });

    notifyListeners();
  }

  void removeProd(ProdCarrinho prodCarrinho){
    Firestore.instance.collection("usuarios").document(user.firebaseUser.uid)
        .collection("carrinho").document(prodCarrinho.id).delete();

    products.remove(prodCarrinho);
    notifyListeners();
  }


  void atualizarPrecos(){
    notifyListeners();
  }

  void removerItemCarrinho(ProdCarrinho cartProduct){
    Firestore.instance.collection("usuarios").document(user.firebaseUser.uid)
        .collection("carrinho").document(cartProduct.id).delete();

    products.remove(cartProduct);

    notifyListeners();
  }


  void decProduct(ProdCarrinho cartProduct){
    cartProduct.qtd--;

    Firestore.instance.collection("usuarios").document(user.firebaseUser.uid).collection("carrinho")
        .document(cartProduct.id).updateData(cartProduct.toMap());

    notifyListeners();
  }

  void incProduct(ProdCarrinho cartProduct){
    cartProduct.qtd++;

    Firestore.instance.collection("usuarios").document(user.firebaseUser.uid).collection("carrinho")
        .document(cartProduct.id).updateData(cartProduct.toMap());

    notifyListeners();
  }


  void _carregarItensCarrinho() async {

    QuerySnapshot query = await Firestore.instance.collection("usuarios").document(user.firebaseUser.uid).collection("carrinho")
        .getDocuments();

    products = query.documents.map((doc) => ProdCarrinho.fromDocument(doc)).toList();

    notifyListeners();
  }

  void setCupom(String couponCode, int discountPercentage){
    this.cupomCode = cupomCode;
    this.desconto = discountPercentage;
  }

  double getPrecoProduto(){
    double price = 0.0;
    for(ProdCarrinho c in products){
      if(c.prodCarrinho != null)
        price += c.qtd * c.prodCarrinho.price;
    }
    return price;
  }

  double getDesconto(){
    return getPrecoProduto() * desconto / 100;
  }

  double getPrecoEntrega(){
    return 2.99;
  }
}