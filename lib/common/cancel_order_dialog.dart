import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/model/order.dart';

class CancelOrderDialog extends StatelessWidget {

  const CancelOrderDialog(this.order);

  final Order order;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cancelar ${order.formattedId}?'),
      content: const Text('Essa não escolha não poderá ser alterada!!!'),
      actions: <Widget>[
        FlatButton(
          onPressed: (){
            order.cancel();
            Navigator.of(context).pop();
          },
          textColor: Colors.red,
          child: const Text('Cancelar pedido'),
        ),
      ],
    );
  }
}
