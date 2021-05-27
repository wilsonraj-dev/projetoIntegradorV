import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/common/custom_drawer/custom_drawer.dart';
import 'package:projeto_pi_flutter/model/admin_orders_manager.dart';
import 'package:projeto_pi_flutter/model/admin_users_managers.dart';
import 'package:projeto_pi_flutter/model/page_manager.dart';
import 'package:provider/provider.dart';

class AdminUsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Usuários'),
        centerTitle: true,
      ),
      body: Consumer<AdminUsersManager>(
        builder: (_, adminUsersManager, __){
          return AlphabetListScrollView(
            itemBuilder: (_, index){
              return ListTile(
                title: Text(
                  adminUsersManager.users[index].nome,
                  style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  adminUsersManager.users[index].email,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: (){
                  context.read<AdminOrdersManager>().setUserFilter(
                    adminUsersManager.users[index]
                  );
                  //context.read<PageManager>().setPage(4);
                },
              );
            },
            highlightTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20
            ),
            indexedHeight: (index) => 80,
            strList: adminUsersManager.nomes,
            showPreview: true,
          );
        },
      )
    );
  }
}
