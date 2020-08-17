import 'package:chefium/models/categoria.dart';
import 'package:chefium/models/comentario.dart';
import 'package:chefium/models/dieta.dart';
import 'package:chefium/models/ingrediente.dart';
import 'package:chefium/models/origen.dart';
import 'package:chefium/models/paso.dart';
import 'package:chefium/models/usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Receta {
  int id;
  String titulo;
  String descripcion;
  DateTime creacion;
  DateTime actualizacion;
  int numerofavoritos;
  String foto;
  String fotoEncoded;
  Usuario usuario;
  String tips;
  int tiempo;
  int porciones;
  bool esMia;
  bool esFavorita;
  List<Comentario> comentarios;
  List<Ingrediente> ingredientes;
  List<Paso> pasos;
  List<String> fotosPasosEncoded;
  List<Categoria> categorias;
  List<Dieta> dietas;
  Origen origen;

  Receta({
    this.id,
    this.titulo,
    this.descripcion,
    this.creacion,
    this.actualizacion,
    this.numerofavoritos,
    this.comentarios,
    this.foto,
    this.usuario,
    this.fotoEncoded,
    this.fotosPasosEncoded,
    this.tips,
    this.tiempo,
    this.porciones,
    this.esMia,
    this.esFavorita,
    this.ingredientes,
    this.pasos,
    this.categorias,
    this.dietas,
    this.origen,
  });

  Receta.empty() {
    this.id = null;
    this.titulo = null;
    this.descripcion = null;
    this.creacion = null;
    this.actualizacion = null;
    this.numerofavoritos = 0;
    this.comentarios = [];
    this.fotoEncoded = null;
    this.fotosPasosEncoded = [];
    this.foto = '';
    this.usuario = Usuario.empty();
    this.tips = null;
    this.tiempo = null;
    this.porciones = null;
    this.esMia = false;
    this.esMia = false;
    this.ingredientes = [];
    this.pasos = [];
    this.categorias = [];
    this.dietas = [];
    this.origen = null;
  }

  factory Receta.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return Receta.empty();
    }
    return Receta(
      id: json['_id'],
      titulo: json['titulo'],
      comentarios: json['comentarios'] != null
          ? Comentario.fromJsonList(json['comentarios'])
          : [],
      descripcion: json['descripcion'],
      creacion:
          json['creacion'] != null ? DateTime.parse(json['creacion']) : null,
      actualizacion: json['actualizacion'] != null
          ? DateTime.parse(json['actualizacion'])
          : null,
      numerofavoritos: json['numeroFavoritos'],
      foto: json['foto'],
      usuario: Usuario.fromJson(json['usuario']),
      tips: json['tips'],
      tiempo: json['tiempoPreparacionMinutos'],
      porciones: json['porciones'],
      esMia: json['esMia'] != null ? json['esMia'] : false,
      esFavorita: json['esFavorita'] != null ? json['esFavorita'] : false,
      ingredientes: Ingrediente.fromJsonList(json['ingredientes']),
      pasos: Paso.fromJsonList(json['pasos']),
      categorias: Categoria.fromJsonList(json['categorias']),
      dietas: Dieta.fromJsonList(json['dietas']),
      origen: json['origen'] != null ? Origen.fromJson(json['origen']) : null,
    );
  }

  static List<Receta> fromJsonList(dynamic json) {
    if (json == null) {
      return [];
    }
    List<Receta> list = [];
    for (var item in json) {
      list.add(Receta.fromJson(item));
    }
    return list;
  }

  Map<String, dynamic> toQuery() {
    String titulo = '';
    String descripcion = '';
    String tips = '';
    int tiempo;
    int porciones;
    List<dynamic> ingredientes = [];
    List<dynamic> pasos = [];
    List<int> categorias = [];
    List<int> dietas = [];
    int origen;

    Map<String, dynamic> query;

    if (this.titulo != null && this.titulo.isNotEmpty) {
      titulo = this.titulo;
    }

    if (this.descripcion != null && this.descripcion.isNotEmpty) {
      descripcion = this.descripcion;
    }

    if (this.foto != null && this.foto.isNotEmpty) {
      foto = this.foto;
    }

    if (this.tips != null && this.tips.isNotEmpty) {
      tips = this.tips;
    }

    if (this.tiempo != null) {
      tiempo = this.tiempo;
    }

    if (this.ingredientes != null && this.ingredientes.isNotEmpty) {
      for (Ingrediente ingrediente in this.ingredientes) {
        ingredientes.add({
          'ingrediente': ingrediente.id,
          'cantidad': ingrediente.cantidad,
          'medida': ingrediente.medida
        });
      }
    }

    if (this.pasos != null && this.pasos.isNotEmpty) {
      for (Paso paso in this.pasos) {
        print(paso.descripcion);
        pasos.add({
          'orden': paso.orden,
          'descripcion': paso.descripcion,
          'fotos': paso.fotosEncoded
        });
      }
    }

    if (this.categorias != null && this.categorias.isNotEmpty) {
      for (Categoria categoria in this.categorias) {
        categorias.add(categoria.id);
      }
    }

    if (this.dietas != null && this.dietas.isNotEmpty) {
      for (Dieta dieta in this.dietas) {
        dietas.add(dieta.id);
      }
    }

    if (this.origen != null) {
      origen = this.origen.id;
    }

    if (this.porciones != null) {
      porciones = this.porciones;
    }

    query = {
      "titulo": titulo,
      "descripcion": descripcion,
      "foto": this.fotoEncoded,
      "categorias": categorias,
      "dietas": dietas,
      "origen": origen,
      "porciones": porciones,
      "tiempoPreparacionMinutos": tiempo,
      "ingredientes": ingredientes,
      "pasos": pasos,
      "tips": tips,
    };

    print(query);

    return query;
  }
}
