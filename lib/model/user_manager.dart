import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:projeto_pi_flutter/helpers/firebase_errors.dart';
import 'package:projeto_pi_flutter/model/user.dart';

class UserManager extends ChangeNotifier{

  UserManager(){
    _loadingCurrentUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final Firestore firestore = Firestore.instance;

  User user;

  bool _loading = false;
  bool get loading => _loading;

  bool get isLoggedIn => user != null;

  Future<void> signIn({User user, Function onFail, Function onSuccess}) async {
    loading = true;
    try{
      final AuthResult result = await auth.signInWithEmailAndPassword(
          email: user.email,
          password: user.senha);

      await _loadingCurrentUser(firebaseUser: result.user);

      onSuccess();
        } on PlatformException catch (e){
          onFail(getErrorString(e.code));
      }
    loading = false;
  }

  //Para enviar ao banco de dados, classe SignUp (Quando está criando a conta)
  Future<void> signUp({User user, Function onFail, Function onSuccess,}) async {
    loading = true;
    try{
      final AuthResult result = await auth.createUserWithEmailAndPassword(
          email: user.email, password: user.senha);

    user.id = result.user.uid;
    this.user = user;

    await user.saveData();

      onSuccess();
    } on PlatformException catch (e){
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  //Saindo do app
  void signOut(){
    auth.signOut();
    user = null;
    notifyListeners();
  }

  set loading(bool value){
    _loading = value;
    notifyListeners();
  }


  //Carregando dados do usuário logado
  Future<void> _loadingCurrentUser({FirebaseUser firebaseUser}) async {
    final FirebaseUser currentUser = firebaseUser ?? await auth.currentUser();
    if(currentUser != null){
      final DocumentSnapshot docUser = await firestore.collection('user')
          .document(currentUser.uid).get();
      user = User.fromDocument(docUser);

      //Verificand se o usuário é administrador
      final docAdmin = await firestore.collection('admins').document(user.id).get();
      if(docAdmin.exists){
        user.admin = true;
      }
      print(user.admin);

      notifyListeners();
    }
  }

  bool get adminEnabled => user != null && user.admin;
}