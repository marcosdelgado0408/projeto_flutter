class MateriaModel{
  final int id;
  final String nome;

  MateriaModel({
    required this.id,
    required this.nome
  });

  factory MateriaModel.fromMap(Map<String, dynamic> map) {
    return MateriaModel(id: map['id'], nome: map['nome']);
  }

}