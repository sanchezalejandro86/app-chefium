import 'package:cached_network_image/cached_network_image.dart';
import 'package:chefium/assets/icons/chefium_icons.dart';
import 'package:chefium/models/paso.dart';
import 'package:chefium/screens/image_view_screen.dart';
import 'package:chefium/themes/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PasoListTile extends StatefulWidget {
  final Paso paso;
  PasoListTile({Key key, @required this.paso}) : super(key: key);
  @override
  _PasoListTileState createState() => _PasoListTileState();
}

class _PasoListTileState extends State<PasoListTile> {
  List<Widget> _obtenerImagenes() {
    List<Widget> widgets = [];
    for (var imagen in widget.paso.fotos) {
      if (widgets.isNotEmpty) {
        widgets.add(Container(width: 10));
      }
      if (imagen != null) {
        widgets.add(
          Expanded(
            child: CachedNetworkImage(
              imageUrl: imagen ?? "",
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
                  height: 130,
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
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
                child: Center(
                  child: Icon(ChefiumIcons.photo),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
                child: Center(
                  child: Icon(ChefiumIcons.photo),
                ),
              ),
            ),
          ),
        );
      }
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 20,
              height: 20,
              margin: EdgeInsets.only(top: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).primaryColor,
              ),
              child: Center(
                child: Text(
                  widget.paso.orden != null
                      ? widget.paso.orden.toString()
                      : "?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            Container(width: 10),
            Expanded(
              child: Text(
                widget.paso.descripcion ?? "Error al cargar el paso",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: MainTheme.gris),
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Flex(
            direction: Axis.horizontal,
            children: _obtenerImagenes(),
          ),
        ),
      ],
    );
  }
}
