import 'package:cloud_firestore/cloud_firestore.dart';

class User{

  User({this.email, this.senha, this.nome, this.confirmarSenha, this.id});

  User.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    nome = document.data['name'] as String;
    email = document.data['email'] as String;
  }

  String id;
  String nome;
  String email;
  String senha;
  String confirmarSenha;

  bool admin = false;


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
    };
  }
}
