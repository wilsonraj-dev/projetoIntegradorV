import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/model/order.dart';
import 'package:projeto_pi_flutter/screen/orders/components/order_product_tile.dart';

class OrderTile extends StatelessWidget {

  const OrderTile(this.order, {this.showControls = false});
  final Order order;
  final bool showControls;

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
              order.statusText,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: order.status == Status.canceled ? Colors.red : Colors.black,
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
          ),

          if(showControls && order.status != Status.canceled)
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  //Cancel
                  IconButton(
                    onPressed: order.cancel,
                    icon: const Icon(Icons.cancel),
                    color: Colors.red,
                  ),

                  //Back
                  IconButton(
                    onPressed: order.back,
                    icon: const Icon(Icons.arrow_left),
                    color: Colors.black,
                  ),

                  //Advanced
                  IconButton(
                    onPressed: order.advance,
                    icon: const Icon(Icons.arrow_right),
                    color: Colors.black,
                  ),

                  //Address
                  IconButton(
                    onPressed: (){

                    },
                    icon: const Icon(Icons.map),
                    color: Colors.green,
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
