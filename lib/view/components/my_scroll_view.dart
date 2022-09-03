import 'package:flutter/material.dart';

class MyScrollView extends StatelessWidget {
  const MyScrollView({
    Key? key,
    required ScrollController scrollControllerH,
    required ScrollController scrollControllerV,
    required this.width,
    required this.height,
    required this.child,
  })  : _scrollControllerH = scrollControllerH,
        _scrollControllerV = scrollControllerV,
        super(key: key);

  final ScrollController _scrollControllerH;
  final ScrollController _scrollControllerV;
  final double width;
  final double height;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        controller: _scrollControllerH,
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          controller: _scrollControllerV,
          child: SizedBox(width: width, height: height, child: child),
        ),
      ),
    );
  }
}
