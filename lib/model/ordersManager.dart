import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:projeto_pi_flutter/model/order.dart';
import 'package:projeto_pi_flutter/model/user.dart';

class OrderManager extends ChangeNotifier{

  User user;
  List<Order> orders = [];

  final Firestore firestore = Firestore.instance;

  StreamSubscription _subscription;

  void updateUser(User user){
    this.user = user;
    _subscription?.cancel();

    if(user != null){
      _listenToOrders();

    }
  }

  void _listenToOrders(){
    _subscription = firestore.collection('orders').
    where('user', isEqualTo: user.id).
    snapshots().listen((event) {
      orders.clear();
      for(final doc in event.documents){
        orders.add(Order.fromDocument(doc));
      }
      notifyListeners();
    });
  }

  @override
  void dispose(){
    super.dispose();
    _subscription?.cancel();
  }
}