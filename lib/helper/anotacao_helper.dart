// Importando as bibliotecas necessárias
import 'package:notas_diarias/model/anotacao.dart';
import 'package:sqflite/sqflite.dart'; // Biblioteca para manipulação de banco de dados SQLite
import 'package:path/path.dart'; // Biblioteca para lidar com caminhos de arquivos

// Classe responsável por gerenciar operações com o banco de dados de anotações
class AnotacaoHelper {
  static const String nomeTabela = "anotacao";

  // Singleton: garantindo que haja apenas uma instância desta classe em toda a aplicação
  static final AnotacaoHelper _anotacaoHelper = AnotacaoHelper._internal();

  // Declaração de variável para armazenar o banco de dados
  Database? _bd; // O '?' indica que a variável pode ser nula

  // Construtor factory para retornar a instância única da classe
  factory AnotacaoHelper() {
    return _anotacaoHelper;
  }

  // Construtor privado para garantir que a classe seja um Singleton
  AnotacaoHelper._internal();

  // Método assíncrono para acessar o banco de dados, inicializando-o se necessário
  get db async {
    if (_bd != null) {
      return _bd; // Se o banco de dados já estiver inicializado, retorna-o
    } else {
      _bd =
          await inicializarDB(); // Caso contrário, inicializar o banco de dados
      return _bd;
    }
  }

  // Método privado assíncrono para criar a tabela no banco de dados
  _onCreate(Database db, int version) async {
    String sql =
        "CREATE TABLE $nomeTabela (id INTEGER PRIMARY KEY AUTOINCREMENT, titulo VARCHAR, descricao TEXT, data DATETIME)";
    await db.execute(sql); // Executa a query SQL para criar a tabela
  }

  // Método assíncrono para inicializar o banco de dados
  inicializarDB() async {
    final caminhoBancoDados =
        await getDatabasesPath(); // Obtém o caminho do banco de dados
    final localBancoDados = join(caminhoBancoDados,
        "banco_minhas_anotacoes.db"); // Junta o caminho com o nome do arquivo do banco

    var db = await openDatabase(localBancoDados,
        version: 1,
        onCreate: _onCreate); // Abre o banco de dados (criando, se não existir)
    return db; // Retorna o banco de dados inicializado
  }

  Future<int> salvarAnotacao(Anotacao anotacao) async {
    var bancoDados = await db;

    int resultado = await bancoDados.insert(nomeTabela, anotacao.toMap());

    return resultado;
  }
}


/*

singleton

class AnotacaoHelper {
  static final AnotacaoHelper _anotacaoHelper = AnotacaoHelper._internal();

  factory AnotacaoHelper() {
    return _anotacaoHelper;
  }

  AnotacaoHelper._internal();
}
*/ 
