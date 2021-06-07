import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/model/address.dart';

class ExportAddressDialog extends StatelessWidget {

  const ExportAddressDialog(this.address);

  final Address address;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Endereço de entrega'),
      content: Text(
        '${address.street}, ${address.number}, ${address.complement}\n'
        '${address.district}\n'
        '${address.city}/${address.state}\n'
        '${address.zipCode}',
      ),
      actions: <Widget>[
        // ignore: deprecated_member_use
        FlatButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        )
      ],
    );
  }
}
