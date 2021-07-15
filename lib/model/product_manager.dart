import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:projeto_pi_flutter/model/product.dart';

class ProductManager extends ChangeNotifier{

  ProductManager(){
    _loadAllProducts();
  }

  final Firestore firestore = Firestore.instance;

  //class Product
  List<Product> allProducts = [];

  //
  String _search = '';
  String get search => _search;
  set search(String value){
    _search = value;
    notifyListeners();
  }
  //

  List<Product> get filteredProducts{
    final List<Product> filteredProducts = [];

    if(search.isEmpty){
      filteredProducts.addAll(allProducts);
    } else{
      filteredProducts.addAll(
        allProducts.where(
          (p) => p.name.toLowerCase().contains(search.toLowerCase())
        )
      );
    }
    return filteredProducts;
  }

  Future<void> _loadAllProducts() async {
    final QuerySnapshot snapProducts =
      await firestore.collection('products').getDocuments();

    allProducts = snapProducts.documents.map(
            (d) => Product.fromDocument(d)).toList();

    notifyListeners();
  }

  Product findProductById(String id){
    try{
      return allProducts.firstWhere((p) => p.id == id);
    } catch (e){
      return null;
    }
  }
  //

  void update(Product product) {
    allProducts.removeWhere((p) => p.id == product.id);
    allProducts.add(product);
    notifyListeners();
  }

}