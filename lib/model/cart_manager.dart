import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:projeto_pi_flutter/model/address.dart';
import 'package:projeto_pi_flutter/model/product.dart';
import 'package:projeto_pi_flutter/model/user.dart';
import 'package:projeto_pi_flutter/model/user_manager.dart';
import 'package:projeto_pi_flutter/services/cepaberto_service.dart';

import 'cart_product.dart';


class CartManager extends ChangeNotifier{

  List<CartProduct> items = [];

  User user;
  Address address;

  num productsPrice = 0.0;

  void updateUser(UserManager userManager){
    user = userManager.user;
    items.clear();

    if(user != null){
      _loadCartItems();
    }
  }

  Future<void> _loadCartItems() async{
     final QuerySnapshot cartSnap = await user.cartRerefence.getDocuments();

     items = cartSnap.documents.map(
         (d) => CartProduct.fromDocument(d)..addListener(_onItemUpdated)
     ).toList();
  }

  //Adicionando produtos
  void addToCart(Product product){
    try{
      final e = items.firstWhere((p) => p.stackable(product));
      e.increment();
    } catch(e){
      final cartProduct = CartProduct.fromProduct(product);
      cartProduct.addListener(_onItemUpdated);
      items.add(cartProduct);
      user.cartRerefence.add(cartProduct.toCartItemMap())
          .then((doc) => cartProduct.id = doc.documentID);
      _onItemUpdated();
    }
    notifyListeners();
  }

  //Removendo produtos
  void removeOfCart(CartProduct cartProduct){
    items.removeWhere((p) => p.id == cartProduct.id);
    user.cartRerefence.document(cartProduct.id).delete();
    cartProduct.removeListener(_onItemUpdated);
    notifyListeners();
  }

  //Atualizando produtos
  void _onItemUpdated(){
    productsPrice = 0.0;
    for(int i=0; i<items.length; i++){
      final cartProduct = items[i];

      if(cartProduct.quantity == 0){
        removeOfCart(cartProduct);
        i--;
        continue;
      }

      productsPrice += cartProduct.totalPrice;

      _updateCartProduct(cartProduct);
    }
     notifyListeners();
  }

  //Atualizando carrinho
  void _updateCartProduct(CartProduct cartProduct){
    if(cartProduct.id != null) {
      user.cartRerefence.document(cartProduct.id).updateData(cartProduct.toCartItemMap());
    }
  }

  bool get isCartValid{
    for(final cartProduct in items){
      if(!cartProduct.hasStock) return false;
    }
    return true;
  }

  //ADDRESS
  Future<void> getAddress(String cep) async{
    final cepAbertoService = CepAbertoService();

    try{
      final cepAbertoAddress = await cepAbertoService.getAddressFromCep(cep);

      if(cepAbertoAddress != null){
        address = Address(
          street: cepAbertoAddress.logradouro,
          district: cepAbertoAddress.bairro,
          zipCode: cepAbertoAddress.cep,
          city: cepAbertoAddress.cidade.nome,
          latitude: cepAbertoAddress.latitude,
          longitude: cepAbertoAddress.longitude
        );
        notifyListeners();
      }
    }
    catch (e){
      debugPrint(e.toString());
    }
  }

}