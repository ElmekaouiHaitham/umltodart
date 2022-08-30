import 'package:flutter/material.dart';

abstract class Shape {
  double xPos;
  double yPos;
  Widget build({bool isPlaced = false});
  void setPosition(x, y) {
    xPos = x;
    yPos = y;
  }

  Shape(this.xPos, this.yPos);
}

class ShapeContainer extends StatelessWidget {
  final Shape shape;
  const ShapeContainer({Key? key, required this.shape}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: shape.xPos,
      top: shape.yPos,
      child: Draggable<Shape>(
        data: shape,
        feedback: shape.build(),
        child: shape.build(),
      ),
    );
  }
}

class Test extends Shape {
  Test(double xPos, double yPos)
      : super(
          xPos,
          yPos,
        );

  @override
  Widget build({bool isPlaced = false}) {
    return Container(
      width: 50,
      height: 50,
      color: Colors.blue,
      child: isPlaced
          ? GestureDetector(
              child: Icon(Icons.add_circle),
              onTap: () {
                print("hello");
              },
            )
          : Container(),
    );
  }
}
