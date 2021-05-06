import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:projeto_pi_flutter/model/product.dart';
import 'item_size.dart';


class CartProduct extends ChangeNotifier{

  CartProduct.fromProduct(this.product){
    productId = product.id;
    quantity = 1;
    size = product.selectedSize.name;
  }

  //Buscando dados dos produtos
  CartProduct.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    productId = document.data['pid'] as String;
    quantity = document.data['quantity'] as int;
    size = document.data['size'] as String;

    firestore.document('products/$productId').get().then(
      (doc) {
        product = Product.fromDocument(doc);
        notifyListeners();
      }
    );
  }

  final Firestore firestore = Firestore.instance;

  String id;
  String productId;
  int quantity;
  String size;

  Product product;

  ItemSize get itemSize{
    if(product == null) return null;
    return product.findSize(size);
  }

  //valor unitário
  num get unitPrice{
    if(product == null) return 0;
    return itemSize?.price ?? 0;
  }

  //valor total
  num get totalPrice => unitPrice * quantity;


  Map<String, dynamic> toCartItemMap(){
    return{
      'pid': productId,
      'quantity': quantity,
      'size': size,
    };
  }


  bool stackable(Product product){
    return product.id == productId && product.selectedSize.name == size;
  }

  //Incrementando numero de produtos
  void increment(){
    quantity++;
    notifyListeners();
  }

  //Decrementando numero de produtos
   void decrement(){
    quantity--;
    notifyListeners();
  }

  //Verificando se tem estoque
  bool get hasStock{
    final size = itemSize;
    if(size == null) return false;
    return size.stock >= quantity;
  }
}