class EstudanteModel{
  late final int matricula;
  late final String nome;
  late final String dataNascimento;
  late final String endereco;
  late final int ano;
  late final String nivelEnsino;

  EstudanteModel({
     required this.matricula,
     required this.nome,
     required this.dataNascimento,
     required this.endereco,
     required this.ano,
     required this.nivelEnsino});



  factory EstudanteModel.fromMap(Map<String, dynamic> map){

    return EstudanteModel(
        matricula: map['matricula'],
        nome: map['nome'],
        dataNascimento: map['dataNascimento'],
        endereco: map['endereco'],
        ano: map['ano'],
        nivelEnsino: map['nivelEnsino']
    );
  }











}