import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chefium/assets/icons/chefium_icons.dart';
import 'package:chefium/models/receta.dart';
import 'package:chefium/screens/receta_screen.dart';
import 'package:chefium/services/usuario_service.dart';
import 'package:chefium/themes/theme.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class AnuncioHorizontal extends StatefulWidget {
  final String adUnitID;

  const AnuncioHorizontal({this.adUnitID, Key key}) : super(key: key);

  @override
  _AnuncioHorizontalState createState() => _AnuncioHorizontalState();
}

class _AnuncioHorizontalState extends State<AnuncioHorizontal> {
  final NativeAdmobController _adController = NativeAdmobController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      height: 150,
      child: NativeAdmob(
        controller: _adController,
        adUnitID: widget.adUnitID,
        loading: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[300],
          ),
        ),
        error: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[300],
          ),
          child: Center(child: Text("No se pudo cargar el anuncio")),
        ),
        type: NativeAdmobType.full,
        options: NativeAdmobOptions(
          showMediaContent: false,
          ratingColor: Theme.of(context).primaryColor,
          headlineTextStyle: NativeTextStyle(
            fontSize: 16,
            color: Theme.of(context).primaryColor,
          ),
          callToActionStyle: NativeTextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
