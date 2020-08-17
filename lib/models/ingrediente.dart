import 'package:fraction/fraction.dart';

class Ingrediente {
  int id;
  String nombre;
  dynamic tipoMedicion;
  String medida;
  dynamic cantidad;

  Ingrediente({
    this.id,
    this.nombre,
    this.medida,
    this.cantidad,
    this.tipoMedicion,
  });

  Ingrediente.empty() {
    this.id = null;
    this.nombre = null;
    this.medida = null;
    this.cantidad = null;
    this.tipoMedicion = null;
  }

  factory Ingrediente.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return Ingrediente.empty();
    }
    return Ingrediente(
        id: json['ingrediente'] != null
            ? json['ingrediente']['_id']
            : (json['_id'] is int ? json['_id'] : null),
        nombre: json['ingrediente'] != null
            ? json['ingrediente']['descripcion']
            : json['descripcion'],
        medida: json['medida'],
        cantidad: json['cantidad'],
        tipoMedicion: json['tipoMedicion']);
  }

  String get oracion {
    String cantidad;
    if (this.cantidad != null) {
      if (this.cantidad is double) {
        cantidad = Fraction.fromDouble(this.cantidad).toString();
      } else {
        cantidad = this.cantidad.toString();
      }
    } else {
      cantidad = 'a gusto';
    }

    String medida = this.medida != null ? this.medida.toString() : '';

    String oracion;

    if (this.cantidad == null && this.medida == null) {
      oracion = "${this.nombre} $cantidad";
    } else if (this.medida != null) {
      oracion = "$cantidad $medida de ${this.nombre}";
    } else {
      oracion = "$cantidad ${this.nombre}";
    }

    return oracion;
  }

  static List<Ingrediente> fromJsonList(dynamic json) {
    if (json == null) {
      return [];
    }
    List<Ingrediente> list = [];
    for (var item in json) {
      list.add(Ingrediente.fromJson(item));
    }
    return list;
  }
}
