import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/common/custom_drawer/price_card.dart';
import 'package:projeto_pi_flutter/model/cart_manager.dart';
import 'package:provider/provider.dart';

import 'components/cart_tile.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrinho"),
        centerTitle: true,
      ),
      body: Consumer<CartManager>(
        builder: (_, cartManager, __){
          return ListView(
            children: <Widget>[
              Column(
              children: cartManager.items.map(
                  (cartProduct) => CartTile(cartProduct)
                ).toList(),
              ),
              //
              PriceCard(
                buttonText: "Continuar para endereço",
                onPressed: cartManager.isCartValid ? (){
                  Navigator.of(context).pushNamed('/address');
                } : null,
              ),
            ],
          );
        },
      ),
    );
  }
}
