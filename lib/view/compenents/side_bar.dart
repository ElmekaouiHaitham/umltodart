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
          Draggable<Shape>(
            data: Test(0,0),
            feedback: Test(0,0).build(),
            child: Test(0,0).build()
          )
        ],
      ),
    );
  }
}
