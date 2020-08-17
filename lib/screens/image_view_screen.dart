import 'package:chefium/assets/icons/chefium_icons.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewScreen extends StatefulWidget {
  final ImageProvider imagen;
  ImageViewScreen({Key key, ImageProvider this.imagen}) : super(key: key);

  @override
  _ImageViewScreenState createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: PhotoView(
              imageProvider: widget.imagen,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black.withOpacity(0.5),
                ),
                child: IconButton(
                  icon: Icon(
                    ChefiumIcons.left_arrow,
                    size: 20,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
