import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/model/cart_manager.dart';
import 'package:projeto_pi_flutter/model/product.dart';
import 'package:projeto_pi_flutter/model/user_manager.dart';
import 'package:provider/provider.dart';
import 'components/size_widiget.dart';

class ProductScreen extends StatelessWidget {

  const ProductScreen(this.product);
  final Product product;

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(
          title: Text(product.name),
          centerTitle: true,
          actions: <Widget>[
            Consumer<UserManager>(
              builder: (_, userManager, __){
                if(userManager.adminEnabled){
                  return IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: (){
                      Navigator.of(context).pushReplacementNamed('/edit_product',
                          arguments: product
                        );
                    },
                  );
                } else {
                  return Container();
                }
              },
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1,
              child: Carousel(
                images: product.images.map((url){
                  return NetworkImage(url);
                }).toList(),
                dotSize: 3,
                dotSpacing: 15,
                dotBgColor: Colors.transparent,
                dotColor: Colors.green,
                autoplay: false,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  //

                  /*const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'A partir de',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 16
                      ),
                    ),
                  ),*/


                  //
                  const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Descrição',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800
                      ),
                    ),
                  ),

                  //
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 17
                    ),
                  ),
                  //

                  //
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Armazenamentos de',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 19
                      ),
                    ),
                  ),
                  //

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product.sizes.map((s){
                      return SizeWidget(size: s);
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  //
                  if(product.hasStock)
                    Consumer2<UserManager, Product>(
                      builder: (_, userManager, product, __){
                        return SizedBox(
                          height: 44,
                          // ignore: deprecated_member_use
                          child: RaisedButton(
                            onPressed: product.selectedSize != null ?(){
                              if(userManager.isLoggedIn){
                                context.read<CartManager>().addToCart(product);
                                Navigator.of(context).pushNamed('/cart');
                              } else {
                                Navigator.of(context).pushNamed('/login');
                              }
                            } : null,

                            color: const Color.fromARGB(255, 12, 38, 30),
                            textColor: Colors.white,
                            disabledColor: Colors.blueGrey.withAlpha(100),
                            child: Text(
                              userManager.isLoggedIn
                                  ? 'Adicionar o carrinho'
                                  : 'Faça login para comprar',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        );
                      }
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
