import 'estudante_model.dart';

class EscolaModel{
  final int cnpj;
  final String nome;
  final String diretor;
  final List<EstudanteModel> estudantes;

  EscolaModel({
    required this.cnpj,
    required this.nome,
    required this.diretor,
    required this.estudantes
  });

  factory EscolaModel.fromMap(Map<String, dynamic> map){

    return EscolaModel(
        cnpj: map['cnpj'],
        nome: map['nome'],
        diretor: map['diretor'],
        estudantes: map['estudantes']
    );

  }














}