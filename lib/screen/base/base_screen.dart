import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/common/custom_drawer/custom_drawer.dart';
import 'package:projeto_pi_flutter/model/page_manager.dart';
import 'package:projeto_pi_flutter/model/user_manager.dart';
import 'package:projeto_pi_flutter/screen/admin_users/admin_users_screen.dart';
import 'package:projeto_pi_flutter/screen/home/home_screen.dart';
import 'package:projeto_pi_flutter/screen/orders/orders_screen.dart';
import 'package:projeto_pi_flutter/screen/products/products_screen.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatefulWidget {

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PageManager(pageController),
      child: Consumer<UserManager>(
        builder: (_, userManager, __){
          return PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              HomeScreen(),
              ProductsScreen(),
              OrdersScreen(),
              Scaffold(
                drawer: CustomDrawer(),
                appBar: AppBar(
                  title: const Text("Home4")
                ),
              ),
              if(userManager.adminEnabled)
                ...[
                  AdminUsersScreen(),
                  Scaffold(
                    drawer: CustomDrawer(),
                    appBar: AppBar(
                      title: const Text("Pedidos")
                    ),
                  ),
                ]
            ],
          );
        },
      ),
    );
  }
}
