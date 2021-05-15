import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/common/custom_drawer/price_card.dart';
import 'package:projeto_pi_flutter/model/cart_manager.dart';
import 'package:projeto_pi_flutter/model/checkout_model.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatelessWidget {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CartManager, CheckoutModel>(
      create: (_) => CheckoutModel(),
      update: (_, cartManager, checkoutModel) =>
        checkoutModel..updateCart(cartManager),
      lazy: false,

      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('Tela de pagamento'),
          centerTitle: true,
        ),
        body: Consumer<CheckoutModel>(
          builder: (_, checkoutModel, __){
            if(checkoutModel.loading){
              return Center(
                child: Column(
                  children: <Widget>[
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                    const SizedBox(height: 16,),
                    Text(
                      'Processando pagamento...',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16
                      ),
                    )
                  ],
                ),
              );
            }
            return ListView(
              children: <Widget>[
                PriceCard(
                  buttonText: 'Finalizar pedido',
                  onPressed: (){
                    checkoutModel.checkout(
                      onStockFail: (e){
                        scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: const Text('Sem estoque suficiente'),
                            backgroundColor: Colors.red,
                          )
                        );
                        //Navigator.of(context).popUntil((route) => route.settings.name == '/cart');
                      },
                      onSuccess: (){
                        Navigator.of(context).popUntil((route) => route.settings.name == '/base');
                      }
                    );
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
