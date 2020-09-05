import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:chefium/assets/icons/chefium_icons.dart';
import 'package:chefium/widgets/imagen_editor_modal.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class FotoInput extends StatefulWidget {
  final Uint8List inicial;
  final String inicialUrl;
  final double iconSize;
  final double maxSize;
  final bool editable;
  final Function(Uint8List) onChanged;

  FotoInput({
    this.onChanged,
    this.inicial,
    this.inicialUrl,
    this.editable = false,
    this.maxSize = 600,
    this.iconSize = 30,
  });

  @override
  _FotoInputState createState() => _FotoInputState();
}

class _FotoInputState extends State<FotoInput> {
  ImagePicker picker = ImagePicker();
  Uint8List _imagen;

  @override
  void initState() {
    super.initState();
    _imagen = widget.inicial;
    if (widget.inicialUrl != null && widget.inicialUrl.isNotEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        Uint8List imagen =
            (await NetworkAssetBundle(Uri.parse(widget.inicialUrl))
                    .load(widget.inicialUrl))
                .buffer
                .asUint8List();
        setState(() {
          _imagen = imagen;
        });
      });
    }
  }

  Future<Uint8List> _getImagen(ImageSource origen) async {
    final imagen = await picker.getImage(source: origen);
    return File(imagen.path).readAsBytesSync();
  }

  Future<Uint8List> _abrirEditor(
      BuildContext context, ImageSource origen) async {
    Uint8List imagenOriginalBytes = await _getImagen(origen);
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImagenEditorModal(
          imagenInicial: imagenOriginalBytes,
          maxSize: widget.maxSize,
          aspectRatio: CropAspectRatios.custom,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.editable
          ? () async {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) => Wrap(
                  children: <Widget>[
                    Dialogo(
                      //hayImagen: _imagen != null || widget.inicialUrl != null,
                      onChanged: (int i) async {
                        switch (i) {
                          case 0:
                            print("Abrir imagen");
                            Navigator.pop(context);
                            break;
                          case 1:
                            setState(() {
                              _imagen = null;
                            });

                            widget.onChanged(null);
                            Navigator.pop(context);
                            break;
                          case 2:
                            Uint8List imagen = await _abrirEditor(
                                context, ImageSource.gallery);
                            setState(() {
                              _imagen = imagen;
                            });

                            widget.onChanged(imagen);
                            Navigator.pop(context);
                            break;
                          case 3:
                            Uint8List imagen =
                                await _abrirEditor(context, ImageSource.camera);
                            setState(() {
                              _imagen = imagen;
                            });

                            widget.onChanged(imagen);
                            Navigator.pop(context);
                            break;
                          default:
                        }
                      },
                    ),
                  ],
                ),
              );
            }
          : null,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFFD8D8D8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: _imagen != null || (widget.inicialUrl != null && widget.inicialUrl.isNotEmpty)
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _imagen != null
                    ? Image.memory(
                        _imagen,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : (widget.inicialUrl != null && widget.inicialUrl.isNotEmpty
                        ? Image.network(
                            widget.inicialUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Container()),
              )
            : Center(
                child: Icon(
                  ChefiumIcons.photo,
                  color: Colors.black.withOpacity(0.5),
                  size: widget.iconSize,
                ),
              ),
      ),
    );
  }
}

class Dialogo extends StatefulWidget {
  final Function(int) onChanged;
  final bool hayImagen;

  const Dialogo({@required this.onChanged, this.hayImagen = false});

  @override
  State createState() => new _DialogoState();
}

class _DialogoState extends State<Dialogo> {
  List<Map<String, dynamic>> opciones = [
    {
      "descripcion": "Ver la foto",
      "icono": Icons.remove_red_eye,
    },
    {
      "descripcion": "Borrar la foto",
      "icono": Icons.delete,
    },
    {
      "descripcion": "Escoger foto desde galeria",
      "icono": Icons.photo_album,
    },
    {
      "descripcion": "Tomar foto desde cámara",
      "icono": Icons.camera,
    },
  ];

  @override
  void initState() {
    super.initState();
    if (!widget.hayImagen) {
      opciones.removeAt(0);
      opciones.removeAt(0);
    }
  }

  Widget build(BuildContext context) {
    return Container(
      height: widget.hayImagen ? 300 : 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              "Selecciona un origen",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Container(height: 15),
          Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.maxFinite,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: opciones.length,
                      itemBuilder: (context, i) => ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 30),
                        onTap: () {
                          int index = widget.hayImagen ? i : i + 2;
                          widget.onChanged(index);
                        },
                        leading: Icon(opciones[i]["icono"]),
                        title: Text(opciones[i]["descripcion"]),
                      ),
                    ),
                  ),
                  Container(height: 10 + MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
