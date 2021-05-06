import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:projeto_pi_flutter/model/user.dart';
import 'package:projeto_pi_flutter/model/user_manager.dart';


class AdminUsersManager extends ChangeNotifier{

  List<User> users = [];

  final Firestore firestore = Firestore.instance;

  StreamSubscription _subscription;

  void updateUser(UserManager userManager){
    _subscription?.cancel();
    if(userManager.adminEnabled){
      _listenToUsers();
    } else {
      users.clear();
      notifyListeners();
    }
  }

  //Listando os usuários
  void _listenToUsers(){
    _subscription = firestore.collection('user').snapshots().listen((snapshot){
      users = snapshot.documents.map((e) => User.fromDocument(e)).toList();
      users.sort((a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()));
      notifyListeners();
    });
  }
  List<String> get nomes => users.map((e) => e.nome).toList();

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}