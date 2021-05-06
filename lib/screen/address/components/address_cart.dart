import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/model/cart_manager.dart';
import 'package:projeto_pi_flutter/screen/address/components/cep_input_field.dart';
import 'package:provider/provider.dart';

class AddressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Consumer<CartManager>(
          builder: (_, cartManager, __){
            final address = cartManager.address;
            print(address);
            return Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Endereço de entrega',
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        fontSize: 16
                    ),
                  ),
                  CepInputField()
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}