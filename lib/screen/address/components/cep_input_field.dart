import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto_pi_flutter/common/custom_drawer/custom_icon_button.dart';
import 'package:projeto_pi_flutter/model/address.dart';
import 'package:projeto_pi_flutter/model/cart_manager.dart';
import 'package:provider/provider.dart';

class CepInputField extends StatefulWidget {

  const CepInputField(this.address);

  final Address address;

  @override
  _CepInputFieldState createState() => _CepInputFieldState();
}

class _CepInputFieldState extends State<CepInputField> {
  final TextEditingController cepController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<CartManager>();

    if(widget.address.zipCode == null)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            enabled: !cartManager.loading,
            controller: cepController,
            decoration: const InputDecoration(
              isDense: true,
              labelText: 'CEP',
            ),
            inputFormatters: [
              // ignore: deprecated_member_use
              WhitelistingTextInputFormatter.digitsOnly,
              CepInputFormatter(),
            ],
            keyboardType: TextInputType.number,
            validator: (cep){
              if(cep.isEmpty){
                return 'Campo obrigatório';
              } else if (cep.length != 10){
                return 'CEP Inválido';
              }
              return null;
            },
          ),
          if(cartManager.loading)
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.green),
              backgroundColor: Colors.transparent,
            ),
          // ignore: deprecated_member_use
          RaisedButton(
            onPressed: !cartManager.loading ? () async{
              if(Form.of(context).validate()){
                try {
                  await context.read<CartManager>().getAddress(cepController.text);
                } catch (e){
                  // ignore: deprecated_member_use
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$e'),
                      backgroundColor: Colors.red,
                    )
                  );
                }
              }
            } : null,
            color: Colors.green,
            textColor: Colors.white,
            child: const Text('Buscar CEP'),
          )
        ],
      );
    else{
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'CEP: ${widget.address.zipCode}',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            CustomIconButton(
              iconData: Icons.edit,
              color: Colors.black,
              size: 20,
              onTap: (){
                context.read<CartManager>().removeAddress();
              },
            )
          ],
        ),
      );
    }
  }
}