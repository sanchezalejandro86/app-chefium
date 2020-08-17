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
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class SquareReceta extends StatefulWidget {
  final Receta receta;

  const SquareReceta({this.receta, Key key}) : super(key: key);

  @override
  _SquareRecetaState createState() => _SquareRecetaState();
}

class _SquareRecetaState extends State<SquareReceta> {
  UsuarioService _usuarioService = UsuarioService();
  bool estado = false;
  int cantidad = 0;

  @override
  void initState() {
    super.initState();
    estado = widget.receta.esFavorita;
    cantidad = widget.receta.numerofavoritos;
  }

  _mostrarLikes() {
    if (widget.receta.esMia) {
      return Container();
    } else {
      if (cantidad != 0) {
        return Column(
          children: <Widget>[
            InkWell(
              child: Padding(
                padding: EdgeInsets.all(7),
                child: Icon(
                    estado ? ChefiumIcons.heart : ChefiumIcons.heart_outlined,
                    color: MainTheme.marronChefium),
              ),
              onTap: () {
                _usuarioService.editarFavoritos(widget.receta.id);
                setState(() {
                  this.estado = !this.estado;
                  if (this.estado) {
                    this.cantidad++;
                  } else {
                    this.cantidad--;
                  }
                });
              },
              borderRadius: BorderRadius.circular(50),
              radius: 10,
            ),
            Padding(
              padding: EdgeInsets.all(0),
              child: Text(
                NumberFormat.compact().format(cantidad),
                style: Theme.of(context).textTheme.subtitle1,
              ),
            )
          ],
        );
      } else {
        return Column(
          children: <Widget>[
            InkWell(
              child: Padding(
                padding: EdgeInsets.all(7),
                child: Icon(
                    estado ? ChefiumIcons.heart : ChefiumIcons.heart_outlined,
                    color: MainTheme.marronChefium),
              ),
              onTap: () {
                _usuarioService.editarFavoritos(widget.receta.id);
                setState(() {
                  this.estado = !this.estado;
                  if (this.estado) {
                    this.cantidad++;
                  } else {
                    this.cantidad--;
                  }
                });
              },
              borderRadius: BorderRadius.circular(50),
              radius: 10,
            ),
          ],
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
        transitionType: ContainerTransitionType.fadeThrough,
        transitionDuration: Duration(milliseconds: 800),
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        closedColor: Colors.white,
        closedElevation: 0,
        openBuilder: (BuildContext context, VoidCallback _) {
          return RecetaScreen(receta: widget.receta);
        },
        tappable: false,
        closedBuilder: (context, action) {
          return InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              action();
            },
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                width: 210,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: widget.receta.foto ?? "",
                      imageBuilder: (context, imageProvider) => Container(
                        height: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          image: DecorationImage(
                              fit: BoxFit.cover, image: imageProvider),
                        ),
                      ),
                      placeholder: (context, url) => Container(
                        height: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          color: Colors.grey[300],
                        ),
                        child: Center(
                          child: Icon(ChefiumIcons.photo),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          color: Colors.grey[300],
                        ),
                        child: Center(
                          child: Icon(ChefiumIcons.photo),
                        ),
                      ),
                    ),
                    Flex(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: 91,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    widget.receta.titulo,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: CircularProfileAvatar(
                                        widget.receta.usuario.foto ?? "",
                                        radius: 15,
                                        backgroundColor: Colors.transparent,
                                        initialsText: Text(
                                          "${widget.receta.usuario.iniciales}",
                                          style: TextStyle(
                                            fontSize: 40,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Por ' +
                                                widget.receta.usuario
                                                    .nombreCompleto,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    color: MainTheme.grisClaro),
                                          ),
                                          Text(
                                            timeago.format(
                                                widget.receta.creacion,
                                                locale: 'es'),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color: MainTheme.grisClaro,
                                                ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        _mostrarLikes()
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
