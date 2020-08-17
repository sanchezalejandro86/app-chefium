class Categoria{
  int id;
  String descripcion;
  DateTime creacion;
  DateTime actualizacion;
  int creadoPor;
  int actualizadoPor;

  Categoria({
    this.id,
    this.descripcion,
    this.creacion,
    this.actualizacion,
    this.creadoPor,
    this.actualizadoPor,
  });

  Categoria.empty(){
    this.id = null;
    this.descripcion = null;
    this.creacion = null;
    this.actualizacion = null;
    this.actualizadoPor = null;
    this.creadoPor = null;
  }

  factory Categoria.fromJson(Map<String,dynamic> json){
    if(json == null){
      return Categoria.empty();
    }
    return Categoria(
      id: json['_id'],
      descripcion: json['descripcion'],
      creacion: json['creacion'] != null
            ? DateTime.parse(json['creacion'])
            : null,
      actualizacion: json['actualizacion'] != null ? DateTime.parse(json['actualizacion']) : null,
      creadoPor: json['creadoPor'],
      actualizadoPor: json['actualizadoPor'],
    );
  }

  static List<Categoria>fromJsonList(dynamic json){
    if(json == null){
      return [];
    }
    List<Categoria> list = [];
    for(var item in json){
      list.add(Categoria.fromJson(item));
    }
    return list;
  }
}