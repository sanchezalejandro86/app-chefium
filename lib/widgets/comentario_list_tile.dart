import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chefium/assets/icons/chefium_icons.dart';
import 'package:chefium/screens/image_view_screen.dart';
import 'package:chefium/widgets/foto_input.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:chefium/models/comentario.dart';
import 'package:timeago/timeago.dart' as timeago;

class ComentarioListTile extends StatelessWidget {
  final Comentario comentario;
  final bool tienePadding;
  final bool mostrarMenu;
  final Function onPressed;
  final Function(Comentario) onDelete;
  final Function(Comentario) onUpdate;

  const ComentarioListTile(
      {Key key,
      this.comentario,
      this.onPressed,
      this.tienePadding = true,
      this.mostrarMenu = false,
      this.onDelete,
      this.onUpdate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: 20, horizontal: tienePadding ? 30 : 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircularProfileAvatar(
                  comentario.creadoPor.foto ?? "",
                  radius: 20,
                  backgroundColor: Theme.of(context).primaryColor,
                  initialsText: Text(
                    comentario.creadoPor.iniciales,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  cacheImage: true,
                ),
                Container(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        comentario.creadoPor.nombreCompleto,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: Theme.of(context).primaryColor),
                      ),
                      Container(height: 5),
                      Text(timeago.format(comentario.creacion, locale: 'es'))
                    ],
                  ),
                ),
                Container(width: 15),
                mostrarMenu
                    ? PopupMenuButton<String>(
                        onSelected: (String option) {
                          switch (option) {
                            case "delete":
                              this.onDelete(comentario);
                              break;
                            case "update":
                              this.onUpdate(comentario);
                              break;
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: "update",
                            child: Text('Editar'),
                          ),
                          const PopupMenuItem<String>(
                            value: "delete",
                            child: Text('Eliminar'),
                          ),
                        ],
                      )
                    : Container()
              ],
            ),
            Container(height: 5),
            Text(
              comentario.contenido ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Container(height: 10),
            comentario.foto != null
                ? CachedNetworkImage(
                    imageUrl: comentario.foto,
                    imageBuilder: (context, imageProvider) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ImageViewScreen(imagen: imageProvider),
                          ),
                        );
                      },
                      child: Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[300],
                      ),
                      child: Center(
                        child: Icon(ChefiumIcons.photo),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[300],
                      ),
                      child: Center(
                        child: Icon(ChefiumIcons.photo),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
