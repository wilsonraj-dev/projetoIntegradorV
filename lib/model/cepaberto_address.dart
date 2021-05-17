class CepAbertoAddress{
  final double altitude;
  final String cep;
  final double latitude;
  final double longitude;
  final String logradouro;
  final String bairro;
  final Cidade cidade;
  final Estado estado;

  CepAbertoAddress.fromMap(Map<String, dynamic> map) :
      altitude = map['altitude'] as double,
      cep = map['cep'] as String,
      latitude = double.tryParse(map['latitude'] as String),
      longitude = double.tryParse(map['longitude'] as String),
      logradouro = map['logradouro'] as String,
      bairro = map['bairro'] as String,
      cidade = Cidade.fromMap(map['cidade'] as Map<String, dynamic>),
      estado = Estado.fromMap(map['estado'] as Map<String, dynamic>);
}

class Cidade {
  final int ddd;
  final String ibge;
  final String nome;

  Cidade.fromMap(Map<String, dynamic> map) :
    ddd = map['ddd'] as int,
    ibge = map['ibge'] as String,
    nome = map['nome'] as String;
}

class Estado {
  final String sigla;

  Estado.fromMap(Map<String, dynamic> map) :
      sigla = map['sigla'] as String;
}