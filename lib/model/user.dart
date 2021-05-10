import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_pi_flutter/model/address.dart';

class User{

  User({this.email, this.senha, this.nome, this.confirmarSenha, this.id});

  User.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    nome = document.data['name'] as String;
    email = document.data['email'] as String;
    if(document.data.containsKey('address')){
      address = Address.fromMap(document.data['address'] as Map<String, dynamic>);
    }
  }

  String id;
  String nome;
  String email;
  String senha;
  String confirmarSenha;

  bool admin = false;

  Address address;

  //Salvando dados do usuário
  DocumentReference get firestoreRef =>
    Firestore.instance.document('user/$id');

  CollectionReference get cartRerefence =>
   firestoreRef.collection('cart');

  Future<void> saveData() async{
    await firestoreRef.setData(toMap());
  }

  Map<String, dynamic> toMap(){
    return {
      'name': nome,
      'email': email,
      if(address != null)
        'address': address.toMap(),
    };
  }

  void setAddress(Address address){
    this.address = address;
    saveData();
  }
}
