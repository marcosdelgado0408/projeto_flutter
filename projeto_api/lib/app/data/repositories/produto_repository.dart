import 'dart:convert';

import 'package:projeto_api/app/data/http/exceptions.dart';
import 'package:projeto_api/app/data/http/http_client.dart';
import 'package:projeto_api/app/data/models/produto_model.dart';

abstract class IprodutoRepository{
  Future<List<ProdutoModel>> getProdutos();
}


class ProdutoRepository implements IprodutoRepository{

  final IHttpClient client;

  ProdutoRepository({ required this.client});


  @override
  Future<List<ProdutoModel>> getProdutos() async{
    final response = await client.get(url: 'https://dummyjson.com/products');

    if(response.statusCode == 200){
      final List<ProdutoModel> produtos = [];
      
      final body = jsonDecode(response.body);

      body['products'].map((item) {
        final ProdutoModel produto = ProdutoModel.fromMap(item);
        produtos.add(produto);
      }).toList();

      return produtos;
    }
    else if(response.statusCode == 404) {
      throw NotFoundException('A url nao funciona');
    }
    else{
      throw Exception('não foi possivel funcionar');
    }



  }


}