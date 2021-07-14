import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/model/product.dart';
import 'package:projeto_pi_flutter/screen/edit_product/components/images_form.dart';
import 'components/sizes_form.dart';

class EditProductScreen extends StatelessWidget {

  EditProductScreen(Product p) : 
      editing = p != null,
      product = p != null ? p.clone() : Product();

  final Product product;
  final bool editing;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(editing ? 'Editar Produtos' : 'Criar Produtos'),
        centerTitle: true,
      ),
            backgroundColor: Colors.white,
            body: Form(
              key: formKey,
              child: ListView(
                children: <Widget>[
                  ImagesForm(product),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                      TextFormField(
                        initialValue: product.name,
                        decoration: InputDecoration(
                          hintText: 'Título',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        validator: (name) {
                          if(name.length < 6)
                            return 'Título muito curto';
                          return null;
                        },
                        onSaved: (name) => product.name = name,
                      ),
                      //
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'A partir de',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13
                          ),
                        ),
                      ),
                      //
                      Text(
                        'R\$ ...',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      //
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 8),
                        child: Text(
                          'Descrição',
                          style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                      //
                      TextFormField(
                        initialValue: product.description,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Descrição',
                          border: InputBorder.none
                        ),
                        maxLines: null,
                        validator: (desc) {
                          if(desc.length < 10)
                            return 'Descrição muito curta';
                          return null;
                        },
                        onSaved: (desc) => product.description = desc,
                      ),
                      //
                      SizesForm(product),
                      const SizedBox(height: 20,),
                      SizedBox(
                        height: 44,
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          onPressed: () {
                            if(formKey.currentState.validate()){
                              formKey.currentState.save();
                              print('Válido');
                            }
                          },
                          textColor: Colors.white,
                          color: Colors.black,
                          disabledColor: Colors.grey[200],
                          child: const Text(
                            'Salvar',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      )
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}