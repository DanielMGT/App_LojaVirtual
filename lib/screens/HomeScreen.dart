import 'package:flutter/material.dart';
import 'package:loja_virtual/CustomDrawer/CustomDrawer.dart';
import 'package:loja_virtual/tabs/BotaoCarrinho.dart';
import 'package:loja_virtual/tabs/HomeTab.dart';
import 'package:loja_virtual/tabs/Pedidos.dart';
import 'package:loja_virtual/tabs/ProductsList.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final _pageController = PageController();

    return PageView(
      controller: _pageController ,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
       Scaffold(
         body: HomeTab(),
         drawer: CustomDrawer(_pageController),
         floatingActionButton: BotaoCarrinho(),
       ),
        Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            centerTitle: true,
            title: Text(
              "Produtos",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
          ),
          drawer: CustomDrawer(_pageController),
          body:ProductsList(),
          floatingActionButton: BotaoCarrinho(),
        ),
        Container(color: Colors.red),
        Scaffold(
          appBar: AppBar(
            title: Text("Meus Pedidos"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: Pedidos(),
        )
      ],
    );
  }
}
