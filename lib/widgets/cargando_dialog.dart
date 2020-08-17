import 'package:chefium/widgets/cargando_indicator.dart';
import 'package:flutter/material.dart';

class CargandoDialog extends StatefulWidget {
  CargandoDialog({Key key}) : super(key: key);

  @override
  _CargandoDialogState createState() => _CargandoDialogState();
}

class _CargandoDialogState extends State<CargandoDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _dialogContent(context),
    );
  }

  _dialogContent(BuildContext context) {
    return CargandoIndicator();
  }
}
