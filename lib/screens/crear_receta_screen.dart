import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:chefium/assets/icons/chefium_icons.dart';
import 'package:chefium/models/categoria.dart';
import 'package:chefium/models/dieta.dart';
import 'package:chefium/models/ingrediente.dart';
import 'package:chefium/models/origen.dart';
import 'package:chefium/models/paso.dart';
import 'package:chefium/models/receta.dart';
import 'package:chefium/models/usuario.dart';
import 'package:chefium/screens/main_screen.dart';
import 'package:chefium/screens/receta_screen.dart';
import 'package:chefium/services/categoria_service.dart';
import 'package:chefium/services/dieta_service.dart';
import 'package:chefium/services/ingrediente_service.dart';
import 'package:chefium/services/origen_service.dart';
import 'package:chefium/services/receta_service.dart';
import 'package:chefium/services/usuario_service.dart';
import 'package:chefium/widgets/cargando_dialog.dart';
import 'package:chefium/widgets/cargando_indicator.dart';
import 'package:chefium/widgets/foto_input.dart';
import 'package:chefium/widgets/preparacion.dart';
import 'package:chefium/widgets/input_origen.dart';
import 'package:chefium/widgets/listview_ingrediente.dart';
import 'package:chefium/widgets/listview_paso.dart';
import 'package:chefium/widgets/input_categorias.dart';
import 'package:chefium/widgets/input_dietas.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CrearRecetaScreen extends StatefulWidget {
  final Receta inicial;
  CrearRecetaScreen({Key key, Receta this.inicial}) : super(key: key);

  @override
  _CrearRecetaScreenState createState() => _CrearRecetaScreenState();
}

class _CrearRecetaScreenState extends State<CrearRecetaScreen> {
  final UsuarioService _usuarioService = UsuarioService();
  CategoriaService _categoriaService = CategoriaService();
  DietaService _dietaService = DietaService();
  OrigenService _origenService = OrigenService();
  IngredienteService _ingredienteService = IngredienteService();
  RecetaService _recetaService = RecetaService();

  ImagePicker picker = ImagePicker();
  ScrollPhysics _actualScroll = ScrollPhysics();
  final _formKey = GlobalKey<FormState>();

  Receta _recetaActual;
  List<Ingrediente> prueba;
  Future<Map<String, dynamic>> _listas;

  Future<Map<String, dynamic>> _obtenerListas() async {
    List<Categoria> categorias = await _categoriaService.obtenerCategorias();
    List<Dieta> dietas = await _dietaService.obetenerDietas();
    List<Origen> origenes = await _origenService.obtenerOrigenes();
    List<Ingrediente> ingredientes =
        await _ingredienteService.obtenerIngredientes();

    return {
      'categorias': categorias,
      'dietas': dietas,
      'ingredientes': ingredientes,
      'origenes': origenes
    };
  }

  @override
  void initState() {
    super.initState();
    _recetaActual = widget.inicial ?? Receta.empty();
    _listas = _obtenerListas();
    prueba = [];
  }

  void _enviarReceta(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => CargandoDialog(),
    );
    try {
      Usuario usuario = await _usuarioService.obtenerUsuarioLocal();

      Receta receta;
      if (widget.inicial == null) {
        receta = await _recetaService.crearReceta(_recetaActual.toQuery());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt("recetasAbiertas", 5);
      } else {
        receta = await _recetaService.editarReceta(
            widget.inicial.id, _recetaActual.toQuery());
      }

      Navigator.pop(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(tabInicial: 0, usuario: usuario),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecetaScreen(receta: receta),
        ),
      );
      Flushbar(
        message: "Receta enviada con éxito",
        duration: Duration(seconds: 5),
        flushbarStyle: FlushbarStyle.GROUNDED,
      )..show(context);
    } catch (e) {
      print(e);
      Navigator.pop(context);
      Flushbar(
        message: "No se pudo enviar la receta",
        duration: Duration(seconds: 5),
        flushbarStyle: FlushbarStyle.GROUNDED,
      )..show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: widget.inicial != null,
        centerTitle: true,
        title: Text(
          widget.inicial != null ? "Editar Receta" : 'Nueva Receta',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      body: FutureBuilder(
        future: _listas,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text('Error trayendo los datos, intente nuevamente'));
          } else {
            if (snapshot.hasData) {
              List<Categoria> categorias = snapshot.data['categorias'];
              List<Dieta> dietas = snapshot.data['dietas'];
              List<Ingrediente> ingredientes = snapshot.data['ingredientes'];
              List<Origen> origenes = snapshot.data['origenes'];
              print("CREAR");
              print(ingredientes[0].id);

              return SingleChildScrollView(
                physics: _actualScroll,
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'General',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Container(
                        height: 180,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: FotoInput(
                          editable: true,
                          iconSize: 70,
                          inicial: _recetaActual.fotoEncoded != null &&
                                  _recetaActual.fotoEncoded.isNotEmpty
                              ? base64.decode(_recetaActual.fotoEncoded)
                              : null,
                          inicialUrl: _recetaActual.fotoEncoded != null &&
                                  _recetaActual.fotoEncoded.isNotEmpty
                              ? null
                              : _recetaActual.foto,
                          onChanged: (foto) {
                            if (foto != null) {
                              setState(() {
                                _recetaActual.fotoEncoded = base64Encode(foto);
                              });
                            } else {
                              setState(() {
                                _recetaActual.fotoEncoded = "";
                              });
                            }
                          },
                        ),
                      ),
                      Container(height: 20),
                      Text(
                        'Nombre de la receta',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      TextFormField(
                        onChanged: (String str) {
                          _recetaActual.titulo = str;
                        },
                        initialValue: _recetaActual.titulo,
                        validator: (valor) {
                          if (valor == null || valor.isEmpty)
                            return "No puede estar vacío";
                          return null;
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Ej: Albóndigas de carne',
                        ),
                      ),
                      Container(height: 20),
                      Text(
                        'Descripción',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      TextFormField(
                        onChanged: (String descripcion) {
                          _recetaActual.descripcion = descripcion;
                        },
                        initialValue: _recetaActual.descripcion,
                        maxLines: 3,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText:
                              'Ej: Plato tradicional infaltable para la cena navideña.',
                        ),
                      ),
                      Container(height: 20),
                      Text(
                        'Orígen',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      InputOrigen(
                        listaOrigen: origenes,
                        ignoreBlank: true,
                        inicial: _recetaActual.origen,
                        onChanged: (nuevoOrigen) {
                          _recetaActual.origen = nuevoOrigen;
                        },
                      ),
                      Container(height: 20),
                      Text(
                        'Categorías',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      InputCategorias(
                        listaCategoria: categorias,
                        inicial: _recetaActual.categorias,
                        onChanged: (List<Categoria> seleccionados) {
                          for (var c in seleccionados) {
                            print(c.descripcion);
                          }
                          _recetaActual.categorias = seleccionados;
                        },
                      ),
                      Container(height: 20),
                      Text(
                        'Tipos de dietas',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      InputDietas(
                        listaDietas: dietas,
                        ignoreBlank: true,
                        inicial: _recetaActual.dietas,
                        onChanged: (List<Dieta> seleccionados) {
                          _recetaActual.dietas = seleccionados;
                        },
                      ),
                      Container(height: 20),
                      Text(
                        'Preparación',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Preparacion(
                        inicial: {
                          "porciones": _recetaActual.porciones,
                          "tiempo": _recetaActual.tiempo,
                        },
                        onChanged: (preparacion) {
                          _recetaActual.porciones = preparacion['porciones'];
                          _recetaActual.tiempo = preparacion['tiempo'];
                        },
                      ),
                      Container(height: 20),
                      Divider(
                        height: 1,
                      ),
                      Container(height: 20),
                      ListViewIngrediente(
                        inicial: _recetaActual.ingredientes,
                        ingredientes: ingredientes,
                        onChanged: (List<Ingrediente> nuevoIngrediente) {
                          _recetaActual.ingredientes = nuevoIngrediente;
                          for (var i in nuevoIngrediente) {
                            print(i == null ? "null" : i.nombre);
                          }
                        },
                        onReorderStarted: () {
                          print("Started");
                          setState(() {
                            _actualScroll = NeverScrollableScrollPhysics();
                          });
                        },
                        onReorderFinished: () {
                          print("Finished");
                          setState(() {
                            _actualScroll = ScrollPhysics();
                          });
                        },
                      ),
                      Container(height: 20),
                      Divider(
                        height: 1,
                      ),
                      Container(height: 20),
                      ListViewPaso(
                        inicial: _recetaActual.pasos,
                        onChanged: (List<Paso> nuevoPaso) {
                          setState(() {
                            _recetaActual.pasos = nuevoPaso;
                          });
                          print(_recetaActual.toQuery());
                        },
                      ),
                      Container(height: 20),
                      Divider(
                        height: 1,
                      ),
                      Container(height: 20),
                      Text(
                        'Tips',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      TextFormField(
                        onChanged: (String tips) {
                          _recetaActual.tips = tips;
                        },
                        initialValue: _recetaActual.tips,
                        maxLines: 3,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Para un mejor resultado',
                        ),
                      ),
                      Container(height: 20),
                      FlatButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            if (_recetaActual.ingredientes.isEmpty) {
                              Flushbar(
                                message: "Debe agregar al menos 1 ingrediente",
                                duration: Duration(seconds: 5),
                                flushbarStyle: FlushbarStyle.GROUNDED,
                              )..show(context);
                            } else if (_recetaActual.pasos.isEmpty) {
                              Flushbar(
                                message: "Debe agregar al menos 1 paso",
                                duration: Duration(seconds: 5),
                                flushbarStyle: FlushbarStyle.GROUNDED,
                              )..show(context);
                            } else {
                              _enviarReceta(context);
                            }
                          } else {
                            Flushbar(
                              message:
                                  "Corrija todos los errores antes de enviar la receta",
                              duration: Duration(seconds: 5),
                              flushbarStyle: FlushbarStyle.GROUNDED,
                            )..show(context);
                          }
                        },
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        child: Container(
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              'Enviar receta',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return CargandoIndicator();
            }
          }
        },
      ),
    );
  }
}
