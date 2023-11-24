import 'package:projeto_api/app/data/models/escola_model.dart';

class DiretorModel{
  final int cpf;
  final String nome;
  final String dataNascimento;
  final String endereco;
  final String escola;

  DiretorModel({
    required this.cpf,
    required this.nome,
    required this.dataNascimento,
    required this.endereco,
    required this.escola
  });


  factory DiretorModel.fromMap(Map<String, dynamic> map){

    return DiretorModel(
        cpf: map['cpf'],
        nome: map['nome'],
        dataNascimento: map['dataNascimento'],
        endereco: map['endereco'],
        escola: map['escola']
    );
  }




}