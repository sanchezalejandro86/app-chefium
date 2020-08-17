class Dieta {
  int id;
  String descripcion;
  String icono;
  DateTime creacion;
  DateTime actualizacion;
  int creadoPor;
  int actualizadoPor;

  Dieta({
    this.id,
    this.descripcion,
    this.icono,
    this.creacion,
    this.actualizacion,
    this.creadoPor,
    this.actualizadoPor,
  });

  Dieta.empty() {
    this.id = null;
    this.descripcion = null;
    this.icono = null;
    this.creacion = null;
    this.actualizacion = null;
    this.actualizadoPor = null;
    this.creadoPor = null;
  }

  factory Dieta.fromJson(dynamic json) {
    if (json == null) {
      return Dieta.empty();
    }
    if (json is Map) {
      return Dieta(
        id: json['_id'],
        descripcion: json['descripcion'],
        icono: json["icono"],
        creacion:
            json['creacion'] != null ? DateTime.parse(json['creacion']) : null,
        actualizacion: json['actualizacion'] != null
            ? DateTime.parse(json['actualizacion'])
            : null,
        creadoPor: json['creadoPor'],
        actualizadoPor: json['actualizadoPor'],
      );
    } else {
      return Dieta(
        id: json,
      );
    }
  }

  static List<Dieta> fromJsonList(dynamic json) {
    if (json == null) {
      return [];
    }
    List<Dieta> list = [];
    for (var item in json) {
      list.add(Dieta.fromJson(item));
    }
    return list;
  }
}
