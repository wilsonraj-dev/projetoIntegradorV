import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto_pi_flutter/model/item_size.dart';

class EditItemSize extends StatelessWidget {

  const EditItemSize({this.size});
  final ItemSize size;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextFormField(
            initialValue: size.name,
            decoration: const InputDecoration(
              labelText: "Título",
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: TextFormField(
            initialValue: size.stock.toString(),
            decoration: const InputDecoration(
              labelText: "Estoque",
              isDense: true,
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: TextFormField(
            initialValue: size.price.toStringAsFixed(2),
            decoration: InputDecoration(
              labelText: "Preço",
              isDense: true
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
        )
      ],
    );
  }
}