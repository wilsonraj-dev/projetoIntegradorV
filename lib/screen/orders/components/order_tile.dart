import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/model/order.dart';

import 'order_product_tile.dart';

class OrderTile extends StatelessWidget {

  const OrderTile(this.order);
  final Order order;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  order.formattedId,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.black
                  ),
                ),
                Text(
                  'R\$ ${order.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                )
              ],
            ),
            Text(
              'Em trânsito',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 14
              ),
            )
          ],
        ),
        children: <Widget>[
          Column(
            children: order.items.map((e){
              return OrderProductTile(e);
          }).toList(),
          )
        ],
      ),
    );
  }
}
