import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/helpers/validators.dart';
import 'package:projeto_pi_flutter/model/user.dart';
import 'package:projeto_pi_flutter/model/user_manager.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {

  //Acionando os validators
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final User user = User();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Criar conta'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Consumer<UserManager>(
              // ignore: missing_return
              builder: (_, userManager, __){
                return ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Nome Completo'),
                      enabled: !userManager.loading,
                      //Validação do nome
                      validator: (nome){
                        if(nome.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        else if(nome.trim().split(' ').length <= 1) {
                          return 'Preencha seu nome completo';
                        }
                        return null;
                      },
                      onSaved: (nome) => user.nome = nome,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      enabled: !userManager.loading,

                      //Validação do email
                      validator: (email){
                        if(email.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        else if(!emailValid(email)) {
                          return 'Email inválido';
                        }
                        return null;
                      },
                      onSaved: (email) => user.email = email,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Senha'),
                      obscureText: true,
                      enabled: !userManager.loading,

                      //Validação da senha
                      validator: (senha){
                        if(senha.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        else if(senha.length < 6) {
                          return 'Senha muito curta';
                        }
                        else if(senha.length > 20) {
                          return 'Senha muito longa';
                        }
                        return null;
                      },
                      onSaved: (senha) => user.senha = senha,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Repita a Senha'),
                      obscureText: true,
                      enabled: !userManager.loading,

                      //Validação confirmação da senha
                      validator: (senha){
                        if(senha.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        else if(senha.length < 6) {
                          return 'Senha muito curta';
                        }
                        else if(senha.length > 20) {
                          return 'Senha muito longa';
                        }
                        return null;
                      },
                      onSaved: (senha) => user.confirmarSenha = senha,
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      height: 44,
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        disabledColor: Theme.of(context).primaryColor.withAlpha(100),
                        textColor: Colors.white,
                        onPressed: userManager.loading ? null : (){
                          if(formKey.currentState.validate()){
                            formKey.currentState.save();

                            //
                            if(user.senha != user.confirmarSenha){
                              scaffoldKey.currentState.showSnackBar(
                                  const SnackBar(
                                    content: Text('Senhas não são iguais'),
                                    backgroundColor: Colors.red,
                                  )
                              );
                              return;
                            }
                            //

                            userManager.signUp(
                                user: user,
                                onSuccess: (){
                                  Navigator.of(context).pop();
                                },

                              onFail: (e){
                                SnackBar(
                                  content: Text('Falha ao cadastrar: $e'),
                                  backgroundColor: Colors.red,
                                );
                              }
                            );
                          }
                        },
                        child: userManager.loading ?
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        )
                        : const Text(
                            'Criar Conta',
                            style: TextStyle(
                              fontSize: 18
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
