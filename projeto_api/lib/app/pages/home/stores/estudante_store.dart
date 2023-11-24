import 'package:flutter/cupertino.dart';
import 'package:projeto_api/app/data/models/estudante_model.dart';
import 'package:projeto_api/app/data/repositories/estudante_repository.dart';

class EstudanteStore{

  final IestudanteRepository repository;

  EstudanteStore({required this.repository});

  // variavel para saber se está carregando
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  // vai guardar o estado com a lista de produtos
  final ValueNotifier<List<EstudanteModel>> state = ValueNotifier<List<EstudanteModel>>([]);

  // variavel reativa para erro
  final ValueNotifier<String> erro = ValueNotifier<String>('');


  Future getEstudantes() async{
    isLoading.value = true;


    final result = await repository.getEstudantes();
    state.value = result;

    isLoading.value = false;

  }

  Future postEstudantes(String nome, String data, String endereco, List<String> materias, String ano, String nivel) async{
    isLoading.value = true;

    await repository.postEstudantes(nome, data, endereco, materias, ano, nivel);

    isLoading.value = false;
  }

  Future deleteEstudantes(String matricula) async{
    isLoading.value = true;

    await repository.deleteEstudantes(matricula);

    isLoading.value = false;
  }

  Future putEstudantes(String matricula, String chave, String novoValor) async{
    isLoading.value = true;

    await repository.putEstudantes(matricula, chave, novoValor);

    isLoading.value = false;
  }

  Future saveEstudante(EstudanteModel estudante) async{
    isLoading.value = true;

    await repository.saveEstudante(estudante);

    isLoading.value = false;
  }





}