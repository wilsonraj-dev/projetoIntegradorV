import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/model/product.dart';

class EditProductScreen extends StatelessWidget {

  const EditProductScreen(this.product);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Produtos"),
        centerTitle: true,
      ),
      // ignore: avoid_unnecessary_containers
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: ListView(
          children: const <Widget>[
            Text(
              'Olá a todos vocês',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w200,
                color: Colors.indigo,
              ),
            )
          ],
        ),
      ),
    );
  }
}
