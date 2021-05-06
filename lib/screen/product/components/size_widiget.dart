import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/model/item_size.dart';
import 'package:projeto_pi_flutter/model/product.dart';
import 'package:provider/provider.dart';

class SizeWidget extends StatelessWidget {

  const SizeWidget({this.size});
  final ItemSize size;

  @override
  Widget build(BuildContext context) {
    final product = context.watch<Product>();
    final selected = size == product.selectedSize;

    Color color;
    if(!size.hasStock){
      color = Colors.red;
    }
    else if (selected){
      color = Colors.green;
    }
    else {
      color = Colors.black45;
    }

    return GestureDetector(
      onTap: (){
        if(size.hasStock){
          product.selectedSize = size;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: color
          ),
        ),
        //
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              color: color,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                size.name,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            //

            //
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                'R\$ ${size.price.toStringAsFixed(2)}',
                style: TextStyle(color: color,),
              ),
            )
          ],
        ),
      ),
    );
  }
}
