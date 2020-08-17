import 'dart:convert';

import 'package:chefium/models/comentario.dart';
import 'package:chefium/models/receta.dart';
import 'package:chefium/services/comentario_service.dart';
import 'package:chefium/widgets/cargando_dialog.dart';
import 'package:chefium/widgets/foto_input.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CrearComentarioScreen extends StatefulWidget {
  final Comentario comentario;
  final Receta receta;

  CrearComentarioScreen({Key key, @required this.receta, this.comentario})
      : super(key: key);

  @override
  _CrearComentarioScreenState createState() =>
      new _CrearComentarioScreenState();
}

class _CrearComentarioScreenState extends State<CrearComentarioScreen> {
  ComentarioService _comentarioService = ComentarioService();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _contenidoController;
  String _imagen;

  @override
  void initState() {
    super.initState();
    _contenidoController =
        TextEditingController(text: widget.comentario?.contenido ?? '');
    _imagen = widget.comentario?.foto;
  }

  bool _isEnabled() {
    return _contenidoController.text.isNotEmpty;
  }

  Future<void> _enviarComentario(BuildContext context) async {
    Map<String, dynamic> nuevoComentario = {
      "contenido": _contenidoController.text,
      "receta": widget.receta.id,
      "foto": _imagen,
    };

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => CargandoDialog(),
    );

    try {
      Comentario comentario;
      if (widget.comentario != null) {
        comentario = await _comentarioService.editarComentario(
            widget.comentario.id, nuevoComentario);
      } else {
        comentario = await _comentarioService.crearComentario(nuevoComentario);
      }
      Navigator.pop(context);

      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      Flushbar(
        message: "No se pudo enviar el comentario",
        duration: Duration(seconds: 5),
        flushbarStyle: FlushbarStyle.GROUNDED,
      )..show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final contenidoField = TextFormField(
      controller: _contenidoController,
      textCapitalization: TextCapitalization.sentences,
      onChanged: (val) {
        setState(() {});
      },
      decoration: InputDecoration(
        hintText: "Ingresa tu comentario",
      ),
      maxLines: 3,
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          widget.comentario != null ? "Editar comentario" : "Nuevo comentario",
          style: Theme.of(context).textTheme.headline6,
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  contenidoField,
                  Container(height: 25),
                  Container(
                    height: 180,
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: FotoInput(
                        editable: true,
                        iconSize: 70,
                        inicial: _imagen != null && _imagen.isNotEmpty
                            ? base64.decode(_imagen)
                            : null,
                        inicialUrl: _imagen != null && _imagen.isNotEmpty ||
                                widget.comentario?.foto == null ||
                                widget.comentario.foto.isEmpty
                            ? null
                            : widget.comentario.foto,
                        onChanged: (foto) {
                          if (foto != null) {
                            setState(() {
                              _imagen = base64Encode(foto);
                            });
                          } else {
                            setState(() {
                              _imagen = "";
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  Container(height: 25),
                  FlatButton(
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Container(
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          'Publicar comentario',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ),
                    disabledColor: Colors.grey,
                    onPressed: _isEnabled()
                        ? () async {
                            if (_formKey.currentState.validate()) {
                              _enviarComentario(context);
                            }
                          }
                        : null,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _contenidoController.dispose();
    super.dispose();
  }
}
