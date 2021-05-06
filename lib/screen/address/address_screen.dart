import 'package:flutter/material.dart';

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
          AddressCard()
        ],
      ),
    );
  }
}
