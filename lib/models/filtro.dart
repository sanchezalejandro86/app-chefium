import 'package:chefium/models/categoria.dart';
import 'package:chefium/models/dieta.dart';
import 'package:chefium/models/ingrediente.dart';

import 'origen.dart';

class Filtro {
  String busqueda;
  List<Ingrediente> ingredientes;
  List<Categoria> categorias;
  List<Origen> origenes;
  List<Dieta> dietas;
  List<String> ordenCampo;
  List<bool> ordenAscendente;

  Filtro(
      {this.ingredientes,
      this.categorias,
      this.origenes,
      this.dietas,
      this.ordenCampo,
      this.ordenAscendente});

  Filtro.empty() {
    this.ingredientes = [];
    this.categorias = [];
    this.origenes = [];
    this.dietas = [];
    this.ordenCampo = [];
    this.ordenAscendente = [];
  }

  List<String> toList() {
    List<String> acumulado = [];
    if (this.busqueda != null && this.busqueda.isNotEmpty) {
      acumulado.add(this.busqueda);
    }
    if (this.categorias != null && this.categorias.isNotEmpty) {
      for (Categoria elemento in this.categorias) {
        acumulado.add(elemento.descripcion);
      }
    }
    if (this.origenes != null && this.origenes.isNotEmpty) {
      for (Origen elemento in this.origenes) {
        acumulado.add(elemento.descripcion);
      }
    }
    if (this.dietas != null && this.dietas.isNotEmpty) {
      for (Dieta elemento in this.dietas) {
        acumulado.add(elemento.descripcion);
      }
    }
    if (this.ingredientes != null && this.ingredientes.isNotEmpty) {
      for (Ingrediente elemento in this.ingredientes) {
        acumulado.add(elemento.nombre);
      }
    }
    return acumulado;
  }

  Map<String, dynamic> toQuery([int limite, int pagina]) {
    String busqueda = '';
    String categorias = '';
    String origenes = '';
    String dietas = '';
    String ordenar = '';
    String ingredientes = '';

    Map<String, dynamic> query;

    if (this.busqueda != null && this.busqueda.isNotEmpty) {
      busqueda = this.busqueda;
    }

    if (this.ingredientes != null && this.ingredientes.isNotEmpty) {
      for (Ingrediente ingrediente in this.ingredientes) {
        if (ingredientes.isNotEmpty) {
          ingredientes += ",";
        }
        ingredientes += ingrediente.id.toString();
      }
    }

    if (this.categorias != null && this.categorias.isNotEmpty) {
      for (Categoria categoria in this.categorias) {
        if (categorias.isNotEmpty) {
          categorias += ",";
        }
        categorias += categoria.id.toString();
      }
    }

    if (this.origenes != null && this.origenes.isNotEmpty) {
      for (Origen origen in this.origenes) {
        if (origenes.isNotEmpty) {
          origenes += ",";
        }
        origenes += origen.id.toString();
      }
    }

    if (this.dietas != null && this.dietas.isNotEmpty) {
      for (Dieta dieta in this.dietas) {
        if (dietas.isNotEmpty) {
          dietas += ",";
        }
        dietas += dieta.id.toString();
      }
    }

    for (var i = 0; i < this.ordenCampo.length; i++) {
      if (ordenar.isNotEmpty) {
        ordenar += ",";
      }
      if (!this.ordenAscendente[i]) {
        ordenar += '-';
      }
      ordenar += this.ordenCampo[i];
    }

    query = {
      'busqueda': busqueda,
      'dietas': dietas,
      'origenes': origenes,
      'ingredientes': ingredientes,
      'categorias': categorias,
      'ordenar': ordenar
    };

    if (pagina != null) {
      query["pagina"] = pagina;
    }

    if (limite != null) {
      query["limite"] = limite;
    }

    return query;
  }
}
