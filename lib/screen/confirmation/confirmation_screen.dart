import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/model/order.dart';
import 'package:projeto_pi_flutter/screen/orders/components/order_product_tile.dart';

class ConfirmationScreen extends StatelessWidget {

  const ConfirmationScreen(this.order);

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedido Confirmado'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      order.formattedId,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black
                      ),
                    ),
                    Text(
                      'R\$ ${order.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 14
                      ),
                    )
                  ],
                ),
              ),
              Column(
                children: order.items.map((e){
                  return OrderProductTile(e);
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
