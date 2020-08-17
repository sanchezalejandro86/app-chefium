import 'package:chefium/models/usuario.dart';

class Comentario {
  int id;
  String contenido;
  String foto;
  int numeroLikes;
  int numeroDislikes;
  List<Usuario> likes;
  List<Usuario> disikes;
  Usuario creadoPor;
  DateTime creacion;
  bool esMio;

  Comentario({
    this.id,
    this.contenido,
    this.creadoPor,
    this.foto,
    this.numeroLikes,
    this.numeroDislikes,
    this.likes,
    this.disikes,
    this.esMio,
    this.creacion,
  });

  Comentario.empty() {
    this.id = null;
    this.contenido = null;
    this.esMio = false;
    this.foto = null;
    this.creadoPor = Usuario.empty();
    this.numeroLikes = 0;
    this.creacion = null;
    this.numeroDislikes = 0;
    this.disikes = [];
    this.likes = [];
  }

  factory Comentario.fromJson(dynamic json) {
    if (json == null) {
      return Comentario.empty();
    }
    if (json is Map) {
      return Comentario(
        id: json['_id'],
        creadoPor: Usuario.fromJson(json["creadoPor"]),
        esMio: json["esMio"],
        foto: json["foto"],
        contenido: json['contenido'],
        numeroLikes: json["numeroLikes"],
        creacion:
            json['creacion'] != null ? DateTime.parse(json['creacion']) : null,
        numeroDislikes: json['numeroDislikes'],
        disikes: json['disikes'] != null
            ? Usuario.fromJsonList(json['disikes'])
            : [],
        likes: json['likes'] != null ? Usuario.fromJsonList(json['likes']) : [],
      );
    } else {
      return Comentario(
        id: json,
      );
    }
  }

  static List<Comentario> fromJsonList(dynamic json) {
    if (json == null) {
      return [];
    }
    List<Comentario> list = [];
    for (var item in json) {
      list.add(Comentario.fromJson(item));
    }
    return list;
  }
}
