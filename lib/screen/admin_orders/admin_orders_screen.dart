import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/common/custom_drawer/custom_drawer.dart';
import 'package:projeto_pi_flutter/common/custom_drawer/empty_card.dart';
import 'package:projeto_pi_flutter/common/order_tile.dart';
import 'package:projeto_pi_flutter/model/admin_orders_manager.dart';
import 'package:provider/provider.dart';

class AdminOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Todos os pedidos'),
        centerTitle: true,
      ),
      body: Consumer<AdminOrdersManager>(
        builder: (_, ordersManager, __){
          if(ordersManager.orders.isEmpty){
            return EmptyCard(
              title: 'Sem vendas realizadas!',
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