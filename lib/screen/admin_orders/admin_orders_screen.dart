import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/common/custom_drawer/custom_drawer.dart';
import 'package:projeto_pi_flutter/common/custom_drawer/custom_icon_button.dart';
import 'package:projeto_pi_flutter/common/custom_drawer/empty_card.dart';
import 'package:projeto_pi_flutter/common/order_tile.dart';
import 'package:projeto_pi_flutter/model/admin_orders_manager.dart';
import 'package:projeto_pi_flutter/model/order.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AdminOrdersScreen extends StatelessWidget {

  final PanelController panelController = PanelController();

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
          return SlidingUpPanel(
            controller: panelController,
            body: Column(
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
            ),
            panel: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    if(panelController.isPanelClosed){
                      panelController.open();
                    } else {
                      panelController.close();
                    }
                  },
                  child: Container(
                    height: 40,
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: Text(
                      'Filtros',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: Status.values.map((e){
                      // ignore: missing_required_param
                      return CheckboxListTile(
                        title: Text(Order.getStatusText(e)),
                        dense: true,
                        value: ordersManager.statusFilter.contains(e),
                        onChanged: (v){
                          ordersManager.setStatusFilter(
                            status: e,
                            enabled: v
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            minHeight: 40,
            maxHeight: 240,
          );
        },
      ),
    );
  }
}