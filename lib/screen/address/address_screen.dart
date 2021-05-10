import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/common/custom_drawer/price_card.dart';
import 'package:projeto_pi_flutter/model/cart_manager.dart';
import 'package:provider/provider.dart';

import 'components/address_cart.dart';

class AddressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Endereço de entrega"),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AddressCard(),
          Consumer<CartManager>(
            builder: (_, cartManager, __){
              return PriceCard(
                buttonText: 'Continuar para pagamento',
                onPressed: cartManager.isAddressValid ? (){

                } : null,
              );
            },
          )
        ],
      ),
    );
  }
}
