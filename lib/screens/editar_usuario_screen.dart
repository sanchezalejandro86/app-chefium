import 'package:chefium/models/usuario.dart';
import 'package:chefium/services/usuario_service.dart';
import 'package:chefium/themes/theme.dart';
import 'package:chefium/widgets/cargando_dialog.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditarUsuarioScreen extends StatefulWidget {
  final String tipo;
  final String inicial;
  EditarUsuarioScreen({Key key, @required this.tipo, this.inicial})
      : super(key: key);

  @override
  _EditarUsuarioScreenState createState() => _EditarUsuarioScreenState();
}

class _EditarUsuarioScreenState extends State<EditarUsuarioScreen> {
  UsuarioService _usuarioService = UsuarioService();
  TextEditingController controlador = TextEditingController();

  @override
  void initState() {
    super.initState();
    controlador = TextEditingController(text: widget.inicial ?? "");
  }

  _guardar(String data) async {
    Map<String, dynamic> map = {};

    if (widget.tipo == 'nombres') {
      map['nombres'] = data;
    }
    if (widget.tipo == 'enlace') {
      map['enlace'] = data;
    }
    if (widget.tipo == 'biografia') {
      map['biografia'] = data;
    }
    if (widget.tipo == 'apellidos') {
      map['apellidos'] = data;
    }
    if (widget.tipo == 'correo') {
      map['correo'] = data;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => CargandoDialog(),
    );

    try {
      Usuario editado = await _usuarioService.editarUsuario(map);

      Navigator.pop(context);
      Navigator.pop(context, editado);
    } catch (e) {
      Navigator.pop(context);
      Flushbar(
        message: "No se pudo editar el campo, intenta más tarde",
        duration: Duration(seconds: 5),
        flushbarStyle: FlushbarStyle.GROUNDED,
      )..show(context);
    }
  }

  String label() {
    if (widget.tipo == 'nombres') {
      return 'Nombre';
    }
    if (widget.tipo == 'apellidos') {
      return 'Apellido';
    }
    if (widget.tipo == 'enlace') {
      return 'Enlace';
    }
    if (widget.tipo == 'biografia') {
      return 'Biografía';
    }
    return 'Correo electrónico';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Modificar ${widget.tipo}",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                TextFormField(
                  autofocus: true,
                  controller: controlador,
                  keyboardType: widget.tipo == 'correo'
                      ? TextInputType.emailAddress
                      : TextInputType.text,
                  maxLength: widget.tipo == 'biografia' ? 100 : null,
                  maxLines: widget.tipo == 'biografia' ? 3 : null,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontWeight: FontWeight.normal),
                  decoration: InputDecoration(
                      labelText: label(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      alignLabelWithHint: true),
                ),
                Container(
                  height: 20,
                ),
                FlatButton(
                  color: MainTheme.amarilloChefium,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () {
                    _guardar(controlador.text);
                  },
                  child: Container(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Guardar',
                          style: Theme.of(context)
                              .textTheme
                              .button
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
