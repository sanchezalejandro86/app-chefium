class Paso {
  List<dynamic> fotos;
  int orden;
  String descripcion;
  List<String> fotosEncoded;

  Paso({
    this.fotos,
    this.fotosEncoded,
    this.orden,
    this.descripcion,
  });

  Paso.empty() {
    this.fotos = [];
    this.orden = null;
    this.fotosEncoded = [];
    this.descripcion = null;
  }

  factory Paso.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return Paso.empty();
    }
    return Paso(
      descripcion: json['descripcion'],
      fotos: json['fotos'] != null ? json['fotos'] : [],
      orden: json['orden'],
    );
  }

  static List<Paso> fromJsonList(dynamic json) {
    if (json == null) {
      return [];
    }
    List<Paso> list = [];
    for (var item in json) {
      list.add(Paso.fromJson(item));
    }
    return list;
  }
}
