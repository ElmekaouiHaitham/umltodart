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
      child: Column(children: [
        IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              print("hi");
            }),
        Draggable<Shape>(
          data: shape,
          feedback: shape.build(),
          child: shape.build(),
        ),
      ]),
    );
  }
}

class Class extends Shape {
  Class(double xPos, double yPos)
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
    );
  }
}
