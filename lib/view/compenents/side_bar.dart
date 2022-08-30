import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:umltodart/models/shape.dart';

import '../../constants.dart';

class SideBar extends StatelessWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Draggable<Container>(
            data: Container(
              width: 50,
              height: 50,
              color: Colors.blue,
            ),
            feedback: Container(
              width: 50,
              height: 50,
              color: Colors.blue,
            ),
            child: Container(
              width: 50,
              height: 50,
              color: Colors.green,
            ),
            childWhenDragging: Container(
              width: 50,
              height: 50,
              color: Colors.redAccent,
            ),
          )
        ],
      ),
    );
  }
}
