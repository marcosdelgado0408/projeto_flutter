import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_api/app/data/http/http_client.dart';
import 'package:projeto_api/app/data/models/estudante_model.dart';
import 'package:projeto_api/app/data/repositories/estudante_repository.dart';
import 'package:projeto_api/app/data/repositories/produto_repository.dart';
import 'package:projeto_api/app/pages/home/stores/estudante_store.dart';
import 'package:projeto_api/app/pages/home/stores/produto_store.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


// class BancoLocal{
//
//   _createDatabase() async{
//     final caminhoBanco = await getDatabasesPath();
//     final localBanco = join(caminhoBanco, "banco.db");
//
//     var retorno = await openDatabase(localBanco, version: 1, onCreate: (db, newVersion){
//       String criarTabelas ="""
//       CREATE TABLE Estudante (
//         matricula BIGINT PRIMARY KEY,
//         nome VARCHAR(255) NOT NULL,
//         dataNascimento DATE,
//         endereco VARCHAR(255),
//         ano INT,
//         nivelEnsino VARCHAR(50),
//         materias VARCHAR(255));""";
//
//       db.execute(criarTabelas);
//     });
//
//     print("Está aberto? " + retorno.isOpen.toString());
//
//     print(retorno);
//
//     return retorno;
//
//   }
//
//   _saveFile(String nome, String data, String endereco, String materias, String ano, String nivel) async{
//     Database db = await _createDatabase();
//
//     Map<String, dynamic> dadosUser = {
//       "nome": nome,
//       "data": data,
//       "endereco" : endereco,
//       "materias": materias,
//       "ano": int.parse(ano),
//       "nivelEnsino": nivel
//     };
//
//     int id = await db.insert("Estudante", dadosUser);
//     print("id: ${id}");
//
//   }
// }




class _MyHomePageState extends State<MyHomePage> {


  final ProdutoStore store = ProdutoStore(
    repository: ProdutoRepository(
      client: HttpClient(),
    ),
  );

  final EstudanteStore estudanteStore = EstudanteStore(
      repository: EstudanteRepository(
          client: HttpClient(),
      ),
  );


  @override
  void initState(){
    super.initState();
    // store.getProdutos();
    estudanteStore.getEstudantes();
  }


  Future<void> _navigateTelaPreenchimento(BuildContext context, String valor) async {

    final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TelaPreenche(varName: valor, estudanteStore: estudanteStore)),
    );

    if (!mounted) return;

    setState(() {
      estudanteStore.getEstudantes();
    });

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$result'),
        ),
      );
  }

  Future<void> _navigateTelaUpdate(BuildContext context, String valor, String nome, String dataNascimento, String endereco, String ano, String nivelEnsino) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TelaUpdate(matricula: valor, estudanteStore: estudanteStore, nome: nome, dataNascimento: dataNascimento, endereco: endereco, ano: ano, nivelEnsino: nivelEnsino,)),
    );

    if (!mounted) return;

    setState(() {
      estudanteStore.getEstudantes();
    });


    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$result'),
        ),
      );
  }





    void _deletarEstudante(BuildContext context, String matricula, String nome) async{
      estudanteStore.deleteEstudantes(matricula);

      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.remove(nome);

      setState(() {
        // Altere o estado aqui
      });

    }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Cadastro Estudantes",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body:

      AnimatedBuilder(
        animation: Listenable.merge([
          estudanteStore.isLoading,
          estudanteStore.erro,
          estudanteStore.state,
        ]),

        builder: (context, child){

          if(estudanteStore.isLoading.value){
            return const CircularProgressIndicator(); // caso estiver carregando, ele vai para essa animacao de carregar
          }


          if(estudanteStore.erro.value.isNotEmpty){
            return Center(
              child: Text(
                estudanteStore.erro.value,
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center ,
              ),
            );
          }


          if(estudanteStore.state.value.isEmpty){
            return
            Column(
              children:[
                Text(
                'nenhum item',
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    elevation: 10,
                  ),
                  onPressed: () => _navigateTelaPreenchimento(context, ""),
                  child: Text("Adicionar estudante", style: TextStyle(color: Colors.white)),
                ),
              ]);
          }





          else {
            return
              ListView(
                    children: [
                      for (final item in estudanteStore.state.value)
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                "Nome: ${item.nome}",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Endereço: ${item.endereco}",
                                    style: const TextStyle(
                                      color: Colors.indigo,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Nivel de ensino:  ${item.nivelEnsino}",
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          elevation: 10,
                                        ),
                                        onPressed: () => _deletarEstudante(context, item.matricula.toString(), item.nome.toString()),
                                        child: Text("Remover", style: TextStyle(color: Colors.white)),
                                      ),

                                      TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.blueGrey,
                                          elevation: 10,
                                        ),
                                        onPressed: () => _navigateTelaUpdate(context, item.matricula.toString(), item.nome, item.dataNascimento, item.endereco, item.ano.toString(), item.nivelEnsino),
                                        child: Text("Atualizar dados", style: TextStyle(color: Colors.white)),
                                      ),

                                    ],
                                  ),


                                ],
                              ),
                            ),
                            SizedBox(height: 32),
                          ],
                        ),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          elevation: 10,
                        ),
                        onPressed: () => _navigateTelaPreenchimento(context, ""),
                        child: Text("Adicionar estudante", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  );

          }


        },
      ),
    );
  }

}



class TelaUpdate extends StatelessWidget{
  TelaUpdate({super.key, required this.estudanteStore, required this.matricula, required this.nome, required this.dataNascimento, required this.endereco, required this.ano, required this.nivelEnsino});

  var dataNascimento;
  var endereco;
  var ano;
  var nivelEnsino;
  var matricula;
  var nome;
  var estudanteStore;
  late EstudanteModel estudanteModel;


  TextEditingController chaveController = TextEditingController();
  TextEditingController valorController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Preenche Valores"),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Chave: "),
            SizedBox(
              width: 300,
              child: TextField(
                controller: chaveController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Novo valor: "),
            SizedBox(
              width: 300,
              child: TextField(
                controller: valorController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        TextButton(
          onPressed: () => {
            print("FAZENDO UPDATE"),

            estudanteStore.putEstudantes(matricula, chaveController.text, valorController.text),

            estudanteModel.nome = nome,
            estudanteModel.matricula = matricula,
            estudanteModel.dataNascimento = dataNascimento,
            estudanteModel.endereco = endereco,
            estudanteModel.nivelEnsino = nivelEnsino,
            estudanteModel.ano = ano,

            estudanteStore.saveEstudante(estudanteModel),



            // Navigator.pop(context, retorno)
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.blueGrey.shade400,
            minimumSize: const Size(150, 50),
          ),
          child: const Text(
            "Ok",
            style: TextStyle(color: Colors.white),
          ),
        )
      ]),
    );


  }





}




class TelaPreenche extends StatelessWidget {
  TelaPreenche({super.key, required this.varName, required this.estudanteStore});

  final String varName;
  var estudanteStore;
  late List<String> materias;
  late EstudanteModel estudanteModel = EstudanteModel(matricula: 0, nome: "nome", dataNascimento: "dataNascimento", endereco: "endereco", ano: 0, nivelEnsino: "nivelEnsino");
  GeradorNumeroNaoRepetitivo gerador = GeradorNumeroNaoRepetitivo();



  TextEditingController nomeController = TextEditingController();
  TextEditingController dataController = TextEditingController();
  TextEditingController enderecoController = TextEditingController();
  TextEditingController materiasController = TextEditingController();
  TextEditingController anoController = TextEditingController();
  TextEditingController nivelController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    //final varName = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Preenche Valores"),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Nome: "),
            SizedBox(
              width: 300,
              child: TextField(
                controller: nomeController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Nascimento: "),
            SizedBox(
              width: 300,
              child: TextField(
                controller: dataController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Endereço: "),
            SizedBox(
              width: 300,
              child: TextField(
                controller: enderecoController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Materias: "),
            SizedBox(
              width: 300,
              child: TextField(
                controller: materiasController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Ano: "),
            SizedBox(
              width: 300,
              child: TextField(
                controller: anoController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Nivel: "),
            SizedBox(
              width: 300,
              child: TextField(
                controller: nivelController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        TextButton(
          onPressed: () => {
            print("FAZENDO POST"),
            materias = materiasController.text.split(', '),

            estudanteStore.postEstudantes(
                nomeController.text,
                dataController.text,
                enderecoController.text,
                materias,
                anoController.text,
                nivelController.text
            ),

            print("SALVANDO O ARQUIVO NO BANDO DE DADOS"),



             estudanteModel = EstudanteModel(
                matricula: gerador.gerarNumeroNaoRepetitivo(1000),
                nome: nomeController.text,
                dataNascimento: dataController.text,
                endereco: enderecoController.text,
                ano: int.parse(anoController.text),
                nivelEnsino: nivelController.text
             ),

            estudanteStore.saveEstudante(estudanteModel),


            // bancoLocal._saveFile(
            //   nomeController.text,
            //   dataController.text,
            //   enderecoController.text,
            //   materiasController.text,
            //   anoController.text,
            //   nivelController.text
            // ),

            // Navigator.pop(context),
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.blueGrey.shade400,
            minimumSize: const Size(150, 50),
          ),
          child: const Text(
            "Ok",
            style: TextStyle(color: Colors.white),
          ),
        )
      ]),
    );
  }
}



class GeradorNumeroNaoRepetitivo {
  Set<int> _numerosGerados = Set<int>();

  int gerarNumeroNaoRepetitivo(int limite) {
    if (_numerosGerados.length == limite) {
      throw Exception('Todos os números possíveis já foram gerados');
    }

    int numero;
    do {
      numero = Random().nextInt(limite);
    }
    while (_numerosGerados.contains(numero));

    _numerosGerados.add(numero);

    return numero;
  }
}





