import 'package:flutter/material.dart';
import 'package:umltodart/view/components/shape.dart';

import '../../utils/constants.dart';

class SideBar extends StatelessWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: kSideBarWidth,
      height: MediaQuery.of(context).size.height,
      child: Drawer(
        child: Column(
          children: <Widget>[
            Draggable(data: Class(), feedback: Class(), child: Class()),
            
          ],
        ),
      ),
    );
  }
}
