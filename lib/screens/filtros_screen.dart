import 'package:chefium/assets/icons/chefium_icons.dart';
import 'package:chefium/models/categoria.dart';
import 'package:chefium/models/dieta.dart';
import 'package:chefium/models/filtro.dart';
import 'package:chefium/models/ingrediente.dart';
import 'package:chefium/models/origen.dart';
import 'package:chefium/screens/busqueda_screen.dart';
import 'package:chefium/services/categoria_service.dart';
import 'package:chefium/services/dieta_service.dart';
import 'package:chefium/services/ingrediente_service.dart';
import 'package:chefium/services/origen_service.dart';
import 'package:chefium/widgets/cargando_indicator.dart';
import 'package:chefium/widgets/input_orden.dart';
import 'package:chefium/widgets/selector_ingredientes.dart';
import 'package:chefium/widgets/tags_categorias.dart';
import 'package:chefium/widgets/tags_dietas.dart';
import 'package:chefium/widgets/tags_origenes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FiltrosScreen extends StatefulWidget {
  final Filtro inicial;
  FiltrosScreen({Key key, Filtro this.inicial}) : super(key: key);

  @override
  _FiltrosScreenState createState() => _FiltrosScreenState();
}

class _FiltrosScreenState extends State<FiltrosScreen> {
  CategoriaService _categoriaService = CategoriaService();
  DietaService _dietaService = DietaService();
  OrigenService _origenService = OrigenService();
  IngredienteService _ingredienteService = IngredienteService();

  TextEditingController _busquedaController = TextEditingController();
  FocusNode _busquedaFocusNode = FocusNode();
  Future<Map<String, dynamic>> _filtros;

  Filtro _filtrosActuales;

  Future<Map<String, dynamic>> _obtenerFiltros() async {
    List<Origen> origenes = await _origenService.obtenerOrigenes();
    List<Dieta> dietas = await _dietaService.obetenerDietas();
    List<Categoria> categorias = await _categoriaService.obtenerCategorias();
    List<Ingrediente> ingredientes =
        await _ingredienteService.obtenerIngredientes();
    return {
      "origenes": origenes,
      "dietas": dietas,
      "categorias": categorias,
      "ingredientes": ingredientes,
    };
  }

  @override
  void initState() {
    super.initState();
    _filtrosActuales = widget.inicial != null ? widget.inicial : Filtro.empty();
    _busquedaFocusNode.requestFocus();
    _filtros = _obtenerFiltros();
    if (widget.inicial != null) {
      if (widget.inicial.busqueda != null &&
          widget.inicial.busqueda.isNotEmpty) {
        _busquedaController.text = widget.inicial.busqueda;
      }
    }
  }

  @override
  void dispose() {
    _busquedaFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        automaticallyImplyLeading: false,
        title: TextField(
          autofocus: true,
          controller: _busquedaController,
          focusNode: _busquedaFocusNode,
          textInputAction: TextInputAction.search,
          onSubmitted: (valor) async {
            Filtro actuales = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BusquedaScreen(filtro: _filtrosActuales),
              ),
            );

            setState(() {
              if (actuales != null) {
                _filtrosActuales = actuales;
              }
            });
          },
          onChanged: (actual) {
            setState(() {
              _filtrosActuales.busqueda = actual;
            });
          },
          decoration: InputDecoration(
            hintText: 'Buscar...',
            border: UnderlineInputBorder(),
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              Filtro actuales = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      BusquedaScreen(filtro: _filtrosActuales),
                ),
              );

              setState(() {
                if (actuales != null) {
                  _filtrosActuales = actuales;
                }
              });
            },
            icon: Icon(
              ChefiumIcons.search,
            ),
          ),
        ],
      ),
      body: Container(
        child: FutureBuilder(
          future: _filtros,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error trayendo los filtros, intente nuevamente"),
              );
            } else {
              if (snapshot.hasData && snapshot.data != null) {
                List<Origen> origenes = snapshot.data["origenes"];
                List<Dieta> dietas = snapshot.data["dietas"];
                List<Categoria> categorias = snapshot.data["categorias"];
                List<Ingrediente> ingredientes = snapshot.data["ingredientes"];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Cocinar con lo que tengo',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Container(height: 10),
                        Text(
                          'Ingredientes',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Container(height: 10),
                        SelectorIngredientes(
                          ingredientes: ingredientes,
                          ingredientesIniciales: _filtrosActuales?.ingredientes,
                          onChanged: (List<Ingrediente> seleccionados) {
                            _filtrosActuales.ingredientes = seleccionados;
                          },
                        ),
                        Container(height: 20),
                        Text(
                          'Filtros',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Container(height: 10),
                        Text(
                          'Categorías',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Container(height: 10),
                        TagsCategorias(
                          categorias: categorias,
                          seleccionadasInicial: _filtrosActuales?.categorias,
                          onChanged: (List<Categoria> seleccionadas) {
                            _filtrosActuales.categorias = seleccionadas;
                          },
                        ),
                        Container(height: 20),
                        Text(
                          'Orígenes',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Container(height: 10),
                        TagsOrigenes(
                          origenes: origenes,
                          seleccionadosInicial: _filtrosActuales?.origenes,
                          onChanged: (List<Origen> seleccionados) {
                            _filtrosActuales.origenes = seleccionados;
                          },
                        ),
                        Container(height: 20),
                        Text(
                          'Dietas',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Container(height: 10),
                        TagsDietas(
                          dietas: dietas,
                          seleccionadasInicial: _filtrosActuales?.dietas,
                          onChanged: (List<Dieta> seleccionadas) {
                            _filtrosActuales.dietas = seleccionadas;
                          },
                        ),
                        Container(height: 20),
                        Text(
                          'Ordenar resultados',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Container(height: 10),
                        Text(
                          'Ordenar por',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Container(height: 10),
                        InputOrden(
                          onChanged: (nuevoOrden) {
                            _filtrosActuales.ordenCampo = [];
                            _filtrosActuales.ordenCampo
                                .add(nuevoOrden["campo"]);
                            _filtrosActuales.ordenAscendente = [];
                            _filtrosActuales.ordenAscendente
                                .add(nuevoOrden["valor"]);
                            print(_filtrosActuales.toQuery());
                          },
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
      ),
    );
  }
}
