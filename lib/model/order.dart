import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_pi_flutter/model/address.dart';
import 'package:projeto_pi_flutter/model/cart_manager.dart';
import 'package:projeto_pi_flutter/model/cart_product.dart';

class Order {
  Order.fromCartManager(CartManager cartManager){
    items = List.from(cartManager.items);
    price = cartManager.totalPrice;
    userId = cartManager.user.id;
    address = cartManager.address;
  }

  Order.fromDocument(DocumentSnapshot doc){
    orderId = doc.documentID;

    items = (doc.data['items'] as List<dynamic>).map((e){
      return CartProduct.fromMap(e);
    }).toList();
    price = doc.data['price'] as num;
    userId = doc.data['user'] as String;
    address = Address.fromMap(doc.data['address'] as Map<String, dynamic>);
    date = doc.data['date'] as Timestamp;
  }

  final Firestore firestore = Firestore.instance;

  Future<void> save() async {
    firestore.collection('orders').document(orderId).setData(
      {
        'items': items.map((e) => e.toOrderItemMap()).toList(),
        'price': price,
        'user': userId,
        'address': address.toMap(),
      }
    );
  }

  String orderId;

  List<CartProduct> items;
  num price;
  String userId;
  Address address;

  Timestamp date;

  String get formattedId => '#${orderId.padLeft(6, '0')}';
}