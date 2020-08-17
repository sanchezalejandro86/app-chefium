import 'dart:convert';

Paginacion paginationFromJson(String str, String docsName) =>
    Paginacion.fromJson(json.decode(str), docsName);

class Paginacion {
  int total;
  int limite;
  int paginasTotales;
  int pagina;
  bool tieneAnterior;
  bool tieneSiguiente;
  dynamic docs;

  Paginacion({
    this.total,
    this.limite,
    this.paginasTotales,
    this.pagina,
    this.docs,
    this.tieneAnterior,
    this.tieneSiguiente,
  });

  factory Paginacion.fromJson(dynamic json, String docName) {
    return Paginacion(
      total: json["total"],
      limite: json["limite"],
      paginasTotales: json["paginasTotales"],
      pagina: json["pagina"],
      docs: json[docName],
      tieneAnterior: json["tieneAnterior"],
      tieneSiguiente: json["tieneSiguiente"],
    );
  }
}
