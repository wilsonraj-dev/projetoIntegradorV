import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'item_size.dart';

class Product extends ChangeNotifier{

  Product.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    name = document['name']as String;
    description = document['description']as String;
    images = List<String>.from(document.data['images'] as List<dynamic>);
    sizes = (document.data['sizes'] as List<dynamic> ?? []).map(
              (s) => ItemSize.fromMap(s as Map<String, dynamic>)).toList();
  }

  final Firestore firestore = Firestore.instance;
  DocumentReference get firestoreRef => firestore.document('products/$id');

  String id;
  String name;
  String description;
  List<String> images;
  List<ItemSize> sizes;

  ItemSize _selectedSize;
  ItemSize get selectedSize => _selectedSize;
  set selectedSize(ItemSize value){
    _selectedSize = value;
    notifyListeners();
  }

  int get totalStock{
    int stock = 0;
    for(final size in sizes){
      stock += size.stock;
    }
    return stock;
  }

  bool get hasStock{
    return totalStock > 0;
  }

  ItemSize findSize(String name){
    try{
      return sizes.firstWhere((s) => s.name == name);
    } catch(e) {
      return null;
    }
  }

  List<Map<String, dynamic>> exportSizeList(){
    return sizes.map((size) => size.toMap()).toList();
  }

  Future<void> save() async {
    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'sizes': exportSizeList(),
    };

    if(id == null){
      final doc = await firestore.collection('products').add(data);
      id = doc.documentID;
    } else {
      await firestoreRef.updateData(data);
    }
  }
}