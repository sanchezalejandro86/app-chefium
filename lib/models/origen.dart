class Origen {
  int id;
  String descripcion;
  String paisISO;
  DateTime creacion;
  DateTime actualizacion;
  int creadoPor;
  int actualizadoPor;

  Origen({
    this.id,
    this.descripcion,
    this.creacion,
    this.actualizacion,
    this.creadoPor,
    this.actualizadoPor,
    this.paisISO,
  });

  Origen.empty() {
    this.id = null;
    this.descripcion = null;
    this.creacion = null;
    this.actualizacion = null;
    this.actualizadoPor = null;
    this.creadoPor = null;
    this.paisISO = null;
  }

  factory Origen.fromJson(dynamic json) {
    if (json == null) {
      return Origen.empty();
    }
    if (json is Map) {
      return Origen(
        id: json['_id'],
        descripcion: json['descripcion'],
        creacion:
            json['creacion'] != null ? DateTime.parse(json['creacion']) : null,
        actualizacion: json['actualizacion'] != null
            ? DateTime.parse(json['actualizacion'])
            : null,
        creadoPor: json['creadoPor'],
        actualizadoPor: json['actualizadoPor'],
        paisISO: json['paisISO3166_1'],
      );
    } else {
      return Origen(
        id: json,
      );
    }
  }

  static List<Origen> fromJsonList(dynamic json) {
    if (json == null) {
      return [];
    }
    List<Origen> list = [];
    for (var item in json) {
      list.add(Origen.fromJson(item));
    }
    return list;
  }
}
