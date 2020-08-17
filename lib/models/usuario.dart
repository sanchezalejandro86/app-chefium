import 'package:chefium/models/receta.dart';

class Usuario {
  int id;
  String correo;
  String nombres;
  String apellidos;
  String foto;
  String rol;
  String biografia;
  String enlace;
  String token;
  String appleUid;
  String facebookId;
  String googleId;
  List<Receta> favoritas;
  List<Receta> recetas;
  int numeroSeguidores;
  int numeroSeguidos;
  bool siguiendo;
  bool soyYo;
  DateTime creacion;
  DateTime actualizacion;

  Usuario(
      {this.id,
      this.nombres,
      this.apellidos,
      this.correo,
      this.foto,
      this.rol,
      this.siguiendo,
      this.biografia,
      this.enlace,
      this.token,
      this.appleUid,
      this.facebookId,
      this.soyYo,
      this.numeroSeguidos,
      this.numeroSeguidores,
      this.googleId,
      this.favoritas,
      this.recetas,
      this.creacion,
      this.actualizacion});

  Usuario.empty() {
    this.id = null;
    this.nombres = null;
    this.apellidos = null;
    this.foto = null;
    this.biografia = null;
    this.enlace = null;
    this.correo = null;
    this.siguiendo = false;
    this.numeroSeguidores = null;
    this.numeroSeguidos = null;
    this.rol = null;
    this.soyYo = false;
    this.token = null;
    this.appleUid = null;
    this.facebookId = null;
    this.googleId = null;
    this.favoritas = [];
    this.recetas = [];
    this.creacion = null;
    this.actualizacion = null;
  }

  factory Usuario.fromJson(dynamic json) {
    if (json is int) {
      return Usuario(id: json);
    }
    if (json == null) {
      return Usuario.empty();
    }
    return Usuario(
      id: json['_id'],
      nombres: json['nombres'],
      apellidos: json['apellidos'],
      siguiendo: json["siguiendo"],
      correo: json['correo'],
      foto: json['foto'],
      rol: json['rol'],
      soyYo: json["soyYo"],
      biografia: json['biografia'],
      enlace: json['enlace'],
      token: json['token'],
      numeroSeguidores: json['numeroSeguidores'],
      numeroSeguidos: json['numeroSeguidos'],
      googleId: json['googleId'],
      appleUid: json['appleUid'],
      facebookId: json['facebookId'],
      recetas: Receta.fromJsonList(json['recetas']),
      favoritas: Receta.fromJsonList(json['favoritas']),
      creacion:
          json['creacion'] != null ? DateTime.parse(json['creacion']) : null,
      actualizacion: json['actualizacion'] != null
          ? DateTime.parse(json['actualizacion'])
          : null,
    );
  }

  static List<Usuario> fromJsonList(dynamic json) {
    if (json == null) {
      return [];
    }
    List<Usuario> list = [];
    for (var item in json) {
      list.add(Usuario.fromJson(item));
    }
    return list;
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "nombres": nombres,
      "apellidos": apellidos,
      "correo": correo,
      "foto": foto,
      "soyYo": soyYo,
      "rol": rol,
      "enlace": enlace,
      "biografia": biografia,
      "siguiendo": siguiendo,
      "numeroSeguidores": numeroSeguidores,
      "numeroSeguidos": numeroSeguidos,
      "token": token,
      "googleId": googleId,
      "appleUid": appleUid,
      "facebookId": facebookId
    };
  }

  String get nombreCompleto =>
      "${this.nombres != null && this.nombres.isNotEmpty ? this.nombres : 'Sin'} ${this.apellidos != null && this.apellidos.isNotEmpty ? this.apellidos : 'nombre'}";
  String get iniciales =>
      "${this.nombres != null && this.nombres.isNotEmpty ? this.nombres[0] : 'N'}${this.apellidos != null && this.apellidos.isNotEmpty != null ? this.apellidos[0] : 'N'}";
}
