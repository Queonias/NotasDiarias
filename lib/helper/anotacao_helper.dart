import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AnotacaoHelper {
  static final AnotacaoHelper _anotacaoHelper = AnotacaoHelper._internal();
  Database? _bd;

  factory AnotacaoHelper() {
    return _anotacaoHelper;
  }

  AnotacaoHelper._internal();

  get db async {
    if (_bd != null) {
      return _bd;
    } else {}
  }

  _onCreate(Database db, int version) async {
    String sql =
        "CREATE TABLE anotacao (id INTEGER PRIMARY KEY AUTOINCREMENT, titulo VARCHAR, descricao TEXT, data DATETIME)";
    await db.execute(sql);
  }

  inicializarDB() async {
    final caminhoBancoDados = await getDatabasesPath();
    final locaBancoDados = join(caminhoBancoDados, "banco_minhas_anotacoes.db");

    var db =
        await openDatabase(locaBancoDados, version: 1, onCreate: _onCreate);
    return db;
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
