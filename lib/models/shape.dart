import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

// abstract class Shape extends StatefulWidget {
//   double xPos;
//   double yPos;
//   Shape({Key? key, required this.xPos, required this.yPos}) : super(key: key);
//   Widget _buildShape();
//   @override
//   State<Shape> createState() => _ShapeState();
// }

// class _ShapeState extends State<Shape> {
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       left: widget.xPos,
//       top: widget.yPos,
//       child: Draggable<Shape>(
//         data: widget,
//         feedback: widget._buildShape(),
//         child: widget._buildShape(),
//       ),
//     );
//   }
// }

class Shape extends StatefulWidget {
  double xPos;
  double yPos;
  Shape({Key? key, required this.xPos, required this.yPos}) : super(key: key);

  @override
  State<Shape> createState() => _ShapeState();
}

class _ShapeState extends State<Shape> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.xPos,
      top: widget.yPos,
      child: Draggable<Shape>(
        data: widget,
        feedback: _buildShape(),
        child: _buildShape(),
      ),
    );
  }

  Widget _buildShape() {
    return Container(
      width: 50,
      height: 50,
      color: Colors.redAccent,
    );
  }
}
