import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/model/product.dart';
import 'package:projeto_pi_flutter/screen/edit_product/components/images_form.dart';

class EditProductScreen extends StatelessWidget {

  EditProductScreen(this.product);
  final Product product;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Produtos"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: ListView(
          children: <Widget>[
            ImagesForm(product),
            // ignore: deprecated_member_use
            RaisedButton(
              onPressed: () {
                if(formKey.currentState.validate()){
                  print('Válido');
                }
              },
              child: const Text('Salvar'),
            )
          ],
        ),
      ),
    );
  }
}