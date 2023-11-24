class ProdutoModel{
  final String title;
  final String description;
  final double price;



  ProdutoModel({
    required this.title,
    required this.description,
    required this.price
  });


  // pegar os valores da api e transformar em produtomodel
  factory ProdutoModel.fromMap(Map<String, dynamic> map) {

    return ProdutoModel(title: map['title'], description: map['description'], price: map['price'] * 1.0);
  }


}