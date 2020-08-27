import 'dart:convert';
import 'package:chefium/models/paso.dart';
import 'package:chefium/widgets/foto_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ItemPaso extends StatefulWidget {
  final Function onChanged;
  final Paso inicial;

  ItemPaso({
    Key key,
    this.inicial,
    this.onChanged,
  }) : super(key: key);

  @override
  _ItemPasoState createState() => _ItemPasoState();
}

class _ItemPasoState extends State<ItemPaso> {
  TextEditingController _descripcionController = TextEditingController();

  List<String> _fotos = [];
  List<String> _urls = [];
  String _primeraUrl;
  String _segundaUrl;
  String _terceraUrl;

  @override
  void initState() {
    super.initState();
    _fotos = [null, null, null];
    _descripcionController =
        TextEditingController(text: widget.inicial?.descripcion ?? "");

    if (widget.inicial != null && widget.inicial.fotos != null) {
      _primeraUrl =
          widget.inicial.fotos.length >= 1 ? widget.inicial.fotos[0] : null;
      _segundaUrl =
          widget.inicial.fotos.length >= 2 ? widget.inicial.fotos[1] : null;
      _terceraUrl =
          widget.inicial.fotos.length >= 3 ? widget.inicial.fotos[2] : null;
    }
  }

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          maxLines: 3,
          controller: _descripcionController,
          textCapitalization: TextCapitalization.sentences,
          onChanged: (String texto) {
            widget.onChanged(
                {'descripcion': _descripcionController.text, 'fotos': _fotos});
          },
          decoration: InputDecoration(
            isDense: true,
            hintText: 'Ej: Primero debes encender el...',
            labelStyle: Theme.of(context).textTheme.caption.copyWith(
                  fontWeight: FontWeight.w400,
                  fontFamily: 'SourceSansPro',
                ),
          ),
        ),
        Container(height: 10),
        Row(
          children: <Widget>[
            Expanded(
                child: Container(
              height: 80,
              child: FotoInput(
                editable: true,
                iconSize: 30,
                inicial: _fotos[0] != null && _fotos[0].isNotEmpty
                    ? base64.decode(_fotos[0])
                    : null,
                inicialUrl: _fotos[0] != null && _fotos[0].isNotEmpty
                    ? null
                    : _primeraUrl,
                onChanged: (foto) {
                  if (foto != null) {
                    setState(() {
                      _fotos[0] = base64Encode(foto);
                    });
                  } else {
                    setState(() {
                      _fotos[0] = "";
                    });
                  }
                  widget.onChanged({
                    'descripcion': _descripcionController.text,
                    'fotos': _fotos
                  });
                },
              ),
            )),
            Container(width: 10),
            Expanded(
              child: Container(
                height: 80,
                child: FotoInput(
                  editable: true,
                  iconSize: 30,
                  inicial: _fotos[1] != null && _fotos[1].isNotEmpty
                      ? base64.decode(_fotos[1])
                      : null,
                  inicialUrl: _fotos[1] != null && _fotos[1].isNotEmpty
                      ? null
                      : _segundaUrl,
                  onChanged: (foto) {
                    if (foto != null) {
                      setState(() {
                        _fotos[1] = base64Encode(foto);
                      });
                    } else {
                      setState(() {
                        _fotos[1] = "";
                      });
                    }
                    widget.onChanged({
                      'descripcion': _descripcionController.text,
                      'fotos': _fotos
                    });
                  },
                ),
              ),
            ),
            Container(width: 10),
            Expanded(
              child: Container(
                height: 80,
                child: FotoInput(
                  editable: true,
                  inicial: _fotos[2] != null && _fotos[2].isNotEmpty
                      ? base64.decode(_fotos[2])
                      : null,
                  inicialUrl: _fotos[2] != null && _fotos[2].isNotEmpty
                      ? null
                      : _terceraUrl,
                  onChanged: (foto) {
                    if (foto != null) {
                      setState(() {
                        _fotos[2] = base64Encode(foto);
                      });
                    } else {
                      setState(() {
                        _fotos[2] = "";
                      });
                    }
                    widget.onChanged({
                      'descripcion': _descripcionController.text,
                      'fotos': _fotos
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
