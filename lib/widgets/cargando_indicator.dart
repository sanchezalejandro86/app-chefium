import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CargandoIndicator extends StatelessWidget {
  //final Color color;
  final AnimationController controller;
  final EdgeInsetsGeometry padding;

  CargandoIndicator({
    //this.color = MainTheme.accentColor,
    this.controller,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Center(
        child: Container(
          padding: padding,
          child: SpinKitThreeBounce(
            controller: controller,
            color: Theme.of(context).accentColor,
            size: 20.0,
          ),
        ),
      ),
    );
  }
}
