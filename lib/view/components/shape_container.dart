import 'package:flutter/material.dart';
import 'package:umltodart/controllers/shape_controller.dart';
import 'package:umltodart/view/components/shape.dart';

import '../../utils/constants.dart';

class ShapeContainer extends StatefulWidget {
  final Shape child;
  final Function() onShapeDelete;
  final Function() onLink;
  const ShapeContainer(
      {Key? key,
      required this.child,
      required this.onShapeDelete,
      required this.onLink})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _ShapeContainerState();
}

class _ShapeContainerState extends State<ShapeContainer> {
  @override
  Widget build(BuildContext context) {
    ShapeController shapeController = widget.child.controller;
    return Positioned(
      left: shapeController.xPos,
      top: shapeController.yPos,
      child: Column(children: [
        // actions: remove field(method), delete shape, edit field(method), add field(method),
        _buildActions(),
        Draggable(
          data: widget.child,
          feedback: Container(
            width: kShapeMinWidth,
            height: 150,
            color: Colors.grey,
          ),
          child: widget.child,
        ),
      ]),
    );
  }

  Widget _buildActions() {
    ShapeController shapeController = widget.child.controller;
    return Row(
      children: [
        GestureDetector(
          onTap: widget.onShapeDelete,
          child: const Icon(Icons.delete, color: Colors.red),
        ),
        GestureDetector(
          onTap: shapeController.add,
          child: const Icon(Icons.add),
        ),
        GestureDetector(
          onTap: widget.onLink,
          child: const Icon(Icons.arrow_forward_outlined),
        ),
      ],
    );
  }
}
