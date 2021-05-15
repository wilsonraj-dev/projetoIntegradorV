import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/screen/address/address_screen.dart';
import 'package:projeto_pi_flutter/screen/base/base_screen.dart';
import 'package:projeto_pi_flutter/screen/cart/cart_screen.dart';
import 'package:projeto_pi_flutter/screen/checkout/checkout_screen.dart';
import 'package:projeto_pi_flutter/screen/edit_product/edit_product_screen.dart';
import 'package:projeto_pi_flutter/screen/login/login_screen.dart';
import 'package:projeto_pi_flutter/screen/product/product_screen.dart';
import 'package:projeto_pi_flutter/screen/signup/signup_screen.dart';
import 'package:projeto_pi_flutter/services/cepaberto_service.dart';
import 'package:provider/provider.dart';

import 'model/admin_users_managers.dart';
import 'model/cart_manager.dart';
import 'model/home_manager.dart';
import 'model/product.dart';
import 'model/product_manager.dart';
import 'model/user_manager.dart';

void main(){
  runApp(MyApp());

  CepAbertoService().getAddressFromCep('13.087-000').then((address) => print(address));
}

class MyApp extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserManager(), lazy: false),
        ChangeNotifierProvider(create: (_) => ProductManager(), lazy: false),
        ChangeNotifierProvider(create: (_) => HomeManager(), lazy: false),
        ChangeNotifierProxyProvider<UserManager, CartManager>(create: (_) => CartManager(), lazy: false,
          update: (_, userManager, cartManager) => cartManager..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          lazy: false,
          update: (_, userManager, adminUsersManagers) =>
              adminUsersManagers..updateUser(userManager),
        )
    ],


      child: MaterialApp(
        title: 'Projeto Integrador - V',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 12, 38, 30),
          scaffoldBackgroundColor: const Color.fromARGB(255, 12, 38, 30),
          appBarTheme: const AppBarTheme(
            elevation: 2
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
       initialRoute: '/base',
       onGenerateRoute: (settings){
          switch(settings.name){
            //Tela login
            case '/login':
              return MaterialPageRoute(
                builder: (_) => LoginScreen()
              );

            //
            case '/signup':
              return MaterialPageRoute(
                builder: (_) => SignUpScreen()
              );

             //Tela de produto
            case '/product':
              return MaterialPageRoute(
                builder: (_) => ProductScreen(
                  settings.arguments as Product
                )
              );

            //Tela do carrinho
            case '/cart':
              return MaterialPageRoute(
                builder: (_) => CartScreen(),
                //settings: settings
              );

            //Tela do endereço
            case '/address':
              return MaterialPageRoute(
                builder: (_) => AddressScreen()
              );

            //Tela de checkout
            case '/checkout':
              return MaterialPageRoute(
                builder: (_) => CheckoutScreen()
              );

             //Tela de edição de produtos
            case '/edit_product':
              return MaterialPageRoute(
                builder: (_) => EditProductScreen(
                  settings.arguments as Product
                )
              );

            //Tela de início
            case '/base':
            default:
              return MaterialPageRoute(
                builder: (_) => BaseScreen(),
                settings: settings,
              );
          }
        },
      ),
    );
  }
}
