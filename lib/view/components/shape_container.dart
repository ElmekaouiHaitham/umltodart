import 'package:flutter/material.dart';

import '../../models/shape.dart';

class ShapeContainer extends StatefulWidget {
  final Shape shape;
  final Function() onShapeDelete;
  const ShapeContainer(
      {Key? key, required this.shape, required this.onShapeDelete})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _ShapeContainerState();
}

class _ShapeContainerState extends State<ShapeContainer> {
  @override
  Widget build(BuildContext context) {
    Shape shape = widget.shape;

    return Positioned(
      left: shape.xPos,
      top: shape.yPos,
      child: Column(children: [
        // actions: remove field(method), delete shape, edit field(method), add field(method),
        _buildActions(),
        Draggable<Shape>(
          data: shape,
          feedback: shape.build(isPlaced: true),
          child: shape.build(isPlaced: true),
        ),
      ]),
    );
  }

  Widget _buildActions() {
    Shape shape = widget.shape;
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            shape.remove(setState);
          },
          child: const Icon(Icons.remove),
        ),
        GestureDetector(
          onTap: () {
            shape.edit(setState);
          },
          child: const Icon(Icons.edit),
        ),
        GestureDetector(
          onTap: widget.onShapeDelete,
          child: const Icon(Icons.delete, color: Colors.red),
        ),
        GestureDetector(
          child: const Icon(Icons.add),
          onTap: () {
            shape.add(setState);
          },
        ),
      ],
    );
  }
}
