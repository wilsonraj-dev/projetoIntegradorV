import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/common/custom_drawer/custom_drawer.dart';
import 'package:projeto_pi_flutter/common/custom_drawer/empty_card.dart';
import 'package:projeto_pi_flutter/common/custom_drawer/login_card.dart';
import 'package:projeto_pi_flutter/model/ordersManager.dart';
import 'package:provider/provider.dart';

import 'components/order_tile.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Meus pedidos'),
        centerTitle: true,
      ),
      body: Consumer<OrderManager>(
        builder: (_, ordersManager, __){
          if(ordersManager.user == null){
            return LoginCard();
          }
          if(ordersManager.orders.isEmpty){
            return EmptyCard(
              title: 'Nada encontrado',
              iconData: Icons.border_clear,
            );
          }
          return ListView.builder(
            itemCount: ordersManager.orders.length,
            itemBuilder: (_, index){
              return OrderTile(
                ordersManager.orders.reversed.toList()[index]
              );
            },
          );
        },
      ),
    );
  }
}
