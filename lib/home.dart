import 'package:flutter/material.dart';
import 'package:notas_diarias/helper/anotacao_helper.dart';
import 'package:notas_diarias/model/anotacao.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final _db = AnotacaoHelper();
  List<Anotacao> _anotacoes = [];

  _exibirTelaCadastro() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Adicionar anotação"),
          content: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _tituloController,
                  autofocus: true,
                  decoration: const InputDecoration(
                      labelText: "Título", hintText: "Digite título"),
                ),
                TextField(
                  controller: _descricaoController,
                  autofocus: false,
                  decoration: const InputDecoration(
                      labelText: "Descrição", hintText: "Digite a descrição"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _salvarAnotacao();
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  _salvarAnotacao() async {
    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;

    Anotacao anotacao = Anotacao(titulo, descricao, DateTime.now().toString());
    int resultado = await _db.salvarAnotacao(anotacao);
    print("resultado: $resultado");

    _tituloController.clear();
    _descricaoController.clear();

    _recuperarAnotacoes();
  }

  _recuperarAnotacoes() async {
    List anotacoesRecuperadas = await _db.recuperarAnotacoes();

    List<Anotacao>? listaTemporaria = [];
    for (var item in anotacoesRecuperadas) {
      Anotacao anotacao = Anotacao.fromMap(item);
      listaTemporaria.add(anotacao);
    }
    setState(() {
      _anotacoes = listaTemporaria!;
    });
    listaTemporaria = null;
    print("Lista anotações: ${anotacoesRecuperadas.toString()}");
  }

  @override
  void initState() {
    super.initState();
    _recuperarAnotacoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minhas anotações"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
            itemCount: _anotacoes.length,
            itemBuilder: (context, index) {
              final item = _anotacoes[index];
              return Card(
                child: ListTile(
                  title: Text(item.titulo),
                  subtitle: Text("${item.data} - ${item.descricao}"),
                ),
              );
            },
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          _exibirTelaCadastro();
        },
      ),
    );
  }
}
