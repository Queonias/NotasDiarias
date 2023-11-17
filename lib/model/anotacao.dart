class Anotacao {
  int? id;
  String titulo;
  String descricao;
  String data;

  Anotacao(this.titulo, this.descricao, this.data);

  Map toMap() {
    Map<String, dynamic> map = {
      "titulo": titulo,
      "descricao": descricao,
      "data": data,
    };

    if (id != null) {
      map["id"] = id;
    }

    return map;
  }
}
