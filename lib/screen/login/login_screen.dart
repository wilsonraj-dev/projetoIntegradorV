import 'package:projeto_pi_flutter/helpers/validators.dart';
import 'package:projeto_pi_flutter/model/user.dart';
import 'package:projeto_pi_flutter/model/user_manager.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {

  final TextEditingController emailController = TextEditingController(); //para validar e fazer o login
  final TextEditingController senhaController = TextEditingController(); //para validar e fazer o login

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text("Entrar"),
        centerTitle: true,
        actions: <Widget>[
          // ignore: deprecated_member_use
          FlatButton(
              onPressed: (){
                Navigator.of(context).pushReplacementNamed('/signup');
              },
              textColor: Colors.white,
              child: const Text("Criar conta", style: TextStyle(fontSize: 14))
          ),
        ],
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Consumer<UserManager>(
              builder: (_, userManager, child){
                return ListView(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  children: <Widget>[
                    TextFormField(
                      controller: emailController,
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(hintText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      // ignore: missing_return
                      validator: (email){
                        if(!emailValid(email)){
                          return 'Email inválido';
                          //return null;
                        }
                      },
                    ),
                    const SizedBox(height: 16,), //aumenta o distaciamento entre os campos Email e Senha
                    TextFormField(
                      controller: senhaController,
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(hintText: 'Senha'),
                      autocorrect: false,
                      obscureText: true,
                      // ignore: missing_return
                      validator: (senha){
                        if(senha.isEmpty || senha.length < 6){
                          return 'Senha inválida';
                          //return null;
                        }
                      },
                    ),
                    child,
                    const SizedBox(height: 16,), //aumenta o distaciamento entre "Esqueci minha senha" e o botão Entrar
                    SizedBox(
                      height: 44, //aumentando o tamanho do botão entrar
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                        onPressed: userManager.loading ? null : (){
                          if(formKey.currentState.validate()){ //Validando o botão entrar
                            userManager.signIn(
                              user: User(
                                email: emailController.text,
                                senha: senhaController.text
                              ),
                              onFail: (e){
                                // ignore: deprecated_member_use
                                scaffoldKey.currentState.showSnackBar(
                                    SnackBar(
                                      content: Text("Falha ao entrar: $e"),
                                      backgroundColor: Colors.red,
                                    )
                                );
                              },
                              onSuccess: (){
                                Navigator.of(context).pop();
                              }
                            );
                          }
                        },
                        color: Theme.of(context).primaryColor,
                        disabledColor: Theme.of(context).primaryColor
                             .withAlpha(100),
                        textColor: Colors.white,
                        child: userManager.loading ?
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ):

                        const Text(
                          "Entrar",
                          style: TextStyle(
                              fontSize: 18
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
              child: Align(
                alignment: Alignment.centerRight,
                // ignore: deprecated_member_use
                child: FlatButton(
                  onPressed: (){
                  },
                  padding: EdgeInsets.zero,
                  child: const Text(
                      "Esqueci minha senha"
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
