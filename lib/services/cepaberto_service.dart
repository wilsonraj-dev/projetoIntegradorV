import 'dart:io';
import 'package:dio/dio.dart';
import 'package:projeto_pi_flutter/model/cepaberto_address.dart';

//API
const token = '6374a864b3a6e1cba68a162c15d05bb7';

class CepAbertoService{
  Future<CepAbertoAddress> getAddressFromCep(String cep) async{
    final cleanCep = cep.replaceAll('.', '').replaceAll('-', '');
    final endpoint = "https://www.cepaberto.com/api/v3/cep?cep=$cleanCep";

    final Dio dio = Dio();
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Token token=$token';

    try{
      final response = await dio.get<Map<String, dynamic>>(endpoint);

      if(response.data.isEmpty){
        return Future.error('CEP inválido');
      }

      final CepAbertoAddress address = CepAbertoAddress.fromMap(response.data);
      return address;

    } on DioError catch (e){
      return Future.error('Erro ao buscar CEP');
    }
  }
}