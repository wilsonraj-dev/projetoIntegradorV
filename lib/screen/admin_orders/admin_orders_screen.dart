import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/common/custom_drawer/custom_drawer.dart';
import 'package:projeto_pi_flutter/common/custom_drawer/custom_icon_button.dart';
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
          final filteredOrders = ordersManager.filteredOrders;

          return Column(
            children: <Widget>[
              if(ordersManager.userFilter != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 2),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Pedidos de ${ordersManager.userFilter.nome}',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.white
                          ),
                        ),
                      ),
                      CustomIconButton(
                        iconData: Icons.close,
                        color: Colors.white,
                        onTap: (){
                          ordersManager.setUserFilter(null);
                        },
                      )
                    ],
                  ),
                ),
              if(filteredOrders.isEmpty)
                Expanded(
                  child: EmptyCard(
                    title: 'Sem vendas realizadas!',
                    iconData: Icons.border_clear,
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredOrders.length,
                    itemBuilder: (_, index){
                      return OrderTile(
                        filteredOrders[index],
                        showControls: true,
                    );
                  },
              ),
                )
            ],
          );
        },
      ),
    );
  }
}