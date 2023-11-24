import 'package:flutter/cupertino.dart';
import 'package:projeto_api/app/data/models/produto_model.dart';
import 'package:projeto_api/app/data/repositories/produto_repository.dart';

class ProdutoStore{

  final IprodutoRepository repository;

  ProdutoStore({required this.repository});


  // variavel para saber se está carregando
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  // vai guardar o estado com a lista de produtos
  final ValueNotifier<List<ProdutoModel>> state = ValueNotifier<List<ProdutoModel>>([]);

  // variavel reativa para erro
  final ValueNotifier<String> erro = ValueNotifier<String>('');


  Future getProdutos() async{
    isLoading.value = true;


      final result = await repository.getProdutos();
      state.value = result;


      isLoading.value = false;
  }

}