import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/common/custom_drawer/custom_drawer.dart';
import 'package:projeto_pi_flutter/model/product_manager.dart';
import 'package:provider/provider.dart';
import 'components/product_list_tile.dart';
import 'components/search_dialog.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Consumer<ProductManager>(
          builder: (_, productManager, __){
            if(productManager.search.isEmpty){
              return const Text('Produtos');
            } else {
              return LayoutBuilder(
                builder: (_, constraints){
                  return GestureDetector(
                    onTap: () async {
                      final search = await showDialog<String>(context: context,
                          builder: (_) => SearchDialog(productManager.search,));
                      if(search != null){
                        productManager.search = search;
                      }
                    },

                    // ignore: sized_box_for_whitespace
                    child: Container(
                      width: constraints.biggest.width,
                      child: Text(productManager.search, textAlign: TextAlign.center),
                    ),
                  );
                },
              );
            }
          },
        ),
        centerTitle: true,
        actions: <Widget>[
          Consumer<ProductManager>(
            builder: (_, productManager, __){
             if(productManager.search.isEmpty){
               return IconButton(
                 icon: const Icon(Icons.search),
                 onPressed: () async {
                   final search = await showDialog<String>(context: context,
                       builder: (_) => SearchDialog(productManager.search));
                   if(search != null){
                     productManager.search = search;
                   }
                 },
               );
             } else {
               return IconButton(
                 icon: const Icon(Icons.close),
                 onPressed: () async {
                   productManager.search = '';
                 },
               );
             }
            }
          )
        ],
      ),

      body: Consumer<ProductManager>(
        builder: (_, productManager, __){
          final filteredProducts = productManager.filteredProducts;
          return ListView.builder(
            padding: const  EdgeInsets.all(5),
            itemCount: filteredProducts.length,
            itemBuilder: (_, index){
              return ProductListTile(filteredProducts[index]);
            }
          );
        }
      ),

      //Botão do carrinho
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromARGB(255, 12, 38, 30),
        onPressed: (){
          Navigator.of(context).pushNamed('/cart');
        },
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
