import 'dart:convert';

import 'package:projeto_api/app/data/http/http_client.dart';
import 'package:projeto_api/app/data/models/estudante_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../http/exceptions.dart';


import 'package:http/http.dart' as http;


abstract class IestudanteRepository{
  Future<List<EstudanteModel>> getEstudantes();
  Future<void> postEstudantes(
      String nome,
      String data,
      String endereco,
      List<String> materias,
      String ano,
      String nivel
      );
  Future<void> deleteEstudantes(String matricula);
  Future<void> putEstudantes(String matricula, String chave, String novoValor);

  Future<void> saveEstudante(EstudanteModel estudante);
}



class EstudanteRepository implements IestudanteRepository{
  
  final IHttpClient client;
  
  EstudanteRepository({required this.client});
  
  
  @override
  Future<List<EstudanteModel>> getEstudantes() async {

    final response = await client.get(url: 'http://10.0.2.2:8080/estudantes');

    if(response.statusCode == 200){


      final List<EstudanteModel> estudantes = [];

      final body = jsonDecode(response.body);

      body['content'].map((item) {
        final EstudanteModel estudante = EstudanteModel.fromMap(item);
        estudantes.add(estudante);
      }).toList();


      return estudantes;

    }

    else if(response.statusCode == 404) {
      throw NotFoundException('A url nao funciona');
    }
    else{
      throw Exception('não foi possivel funcionar');
    }

  }

  @override
  Future<void> postEstudantes( String nome, String data, String endereco, List<String> materias, String ano, String nivel) async{

    // ajeitando a lista de String "materias" para o formato certo
    List<Map<String, String>> materias2 = [];
    
    for(String materia in materias){
      Map<String, String> novoMap = { 'nome': materia };
      materias2.add(novoMap);
    }

    print(materias2);

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/estudantes'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "nome": nome,
        "dataNascimento": data,
        "endereco": endereco,
        "materiasCadastradas": materias2,
        "ano": ano,
        "nivelEnsino": nivel
      }),
    );

    if (response.statusCode == 201) {
      // A resposta do servidor foi bem-sucedida.
      print('Resposta do servidor: ${response.body}');
    }

    else {
      // Se o servidor não retornar um status 200 OK, lançamos uma exceção.
      throw Exception('Falha ao enviar dados para o servidor');
    }

  }

  @override
  Future<void> deleteEstudantes(String matricula) async {

    final url = Uri.parse('http://10.0.2.2:8080/estudantes');

    try {
      final request = http.Request('DELETE', url);

      request.headers.addAll(<String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });

      request.body = jsonEncode({'matricula': matricula});

      final response = await http.Client().send(request);

      if (response.statusCode == 204) {
        print('Requisição DELETE bem-sucedida');
      }
      else {
        print('Erro na requisição DELETE. Código de status: ${response.statusCode}');
        print('Corpo da resposta: ${await response.stream.bytesToString()}');
      }
    }
    catch (error) {
      print('Erro durante a requisição DELETE: $error');
    }

  }

  @override
  Future<void> putEstudantes(String matricula, String chave, String novoValor) async{

    final url = Uri.parse('http://10.0.2.2:8080/estudantes/${matricula}');

    try {
      final response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({chave : novoValor}),
      );

      if (response.statusCode == 200) {
        print('Requisição PUT bem-sucedida');
      }
      else {
        print('Erro na requisição PUT. Código de status: ${response.statusCode}');
        print('Corpo da resposta: ${response.body}');
      }
    }
    catch (error) {
      print('Erro durante a requisição PUT: $error');
    }


  }

  @override
  Future<void> saveEstudante(EstudanteModel estudante) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> estudanteJson = {

      'matricula': estudante.matricula,
      'nome' : estudante.nome,
      'dataNascimento': estudante.dataNascimento,
      'endereco': estudante.endereco,
      'ano': estudante.ano,
      'nivelEnsino': estudante.nivelEnsino

    };

    prefs.setString(estudante.nome, json.encode(estudanteJson));

  }


  
  
  
  
  
}




