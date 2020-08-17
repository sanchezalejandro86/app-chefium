import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:chefium/models/usuario.dart';
import 'package:chefium/widgets/cargando_dialog.dart';
import 'package:chefium/widgets/imagen_editor_modal.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_editor_pro/image_editor_pro.dart';
import 'package:image_picker/image_picker.dart';

class FotoPerfil extends StatefulWidget {
  final double radio;
  final Usuario usuario;
  final bool editable;
  final Function(String) onImagen;
  FotoPerfil(
      {Key key,
      this.radio = 50,
      @required this.usuario,
      this.onImagen,
      this.editable = false})
      : super(key: key);

  @override
  _FotoPerfilState createState() => _FotoPerfilState();
}

class _FotoPerfilState extends State<FotoPerfil> {
  ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CircularProfileAvatar(
          widget.usuario.foto ?? "",
          radius: widget.radio,
          backgroundColor: Colors.transparent,
          initialsText: Text(
            "${widget.usuario.iniciales}",
            style: TextStyle(
              fontSize: 40,
              color: Colors.white,
            ),
          ),
        ),
        widget.editable
            ? InkWell(
                onTap: () async {
                  try {
                    final imagen =
                        await picker.getImage(source: ImageSource.gallery);
                    if (imagen != null) {
                      Uint8List imagenOriginalBytes =
                          File(imagen.path).readAsBytesSync();

                      Uint8List imagenEditadaBytes = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImagenEditorModal(
                            imagenInicial: imagenOriginalBytes,
                            maxSize: 40,
                            aspectRatio: 1,
                          ),
                        ),
                      );

                      String imagenEditadaBase64 =
                          base64Encode(imagenEditadaBytes);

                      widget.onImagen(imagenEditadaBase64);
                    } else {
                      Flushbar(
                        message: "No se pudo obtener la foto",
                        duration: Duration(seconds: 5),
                        flushbarStyle: FlushbarStyle.GROUNDED,
                      )..show(context);
                    }
                  } catch (e) {
                    print(e);
                    Flushbar(
                      message: "Ocurrió un error cambiando la foto",
                      duration: Duration(seconds: 5),
                      flushbarStyle: FlushbarStyle.GROUNDED,
                    )..show(context);
                  }
                },
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
