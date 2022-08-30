// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:umltodart/constants.dart';
// import 'package:umltodart/models/shape.dart';

// import 'compenents/side_bar.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   Container test = Container();
//   Offset offset = Offset.zero;
//   List<Widget> shapes = [];
//   ScrollController _scrollControllerV = ScrollController();
//   ScrollController _scrollControllerH = ScrollController();
//   double height =
//       MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height -
//           55;
//   double width =
//       MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width -
//           100;

//   @override
//   void initState() {
//     super.initState();
//     _scrollControllerV.addListener(() {
//       if (_scrollControllerV.position.atEdge) {
//         setState(() {
//           height += 50;
//         });
//       }
//     });
//     _scrollControllerH.addListener(() {
//       if (_scrollControllerH.position.atEdge) {
//         setState(() {
//           width += 50;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 10,
//         backgroundColor: kMainColor,
//         actions: [
//           IconButton(onPressed: () {}, icon: const Icon(Icons.undo_sharp)),
//           IconButton(
//               onPressed: () {}, icon: const Icon(Icons.play_arrow_sharp)),
//           IconButton(onPressed: () {}, icon: const Icon(Icons.redo_sharp)),
//         ],
//       ),
//       body: Row(
//         children: [
//           SizedBox(
//               width: 200,
//               height: MediaQuery.of(context).size.height,
//               child: SideBar()),
//           Expanded(
//             child: SingleChildScrollView(
//               controller: _scrollControllerH,
//               scrollDirection: Axis.horizontal,
//               child: SingleChildScrollView(
//                 controller: _scrollControllerV,
//                 child: SizedBox(
//                   width: width,
//                   height: height,
//                   child: DragTarget<Shape>(
//                     builder: (context, _, __) {
//                       return Stack(
//                           children: shapes.map((e) {
//                         return e;
//                       }).toList());
//                     },
//                     onAcceptWithDetails: (details) {
//                       setState(() {
//                         Shape shape = details.data;
//                         shape.xPos = details.offset.dx;
//                         shape.yPos = details.offset.dy;
//                         if (!shapes.contains(shape)) {
//                           shapes.add(shape);
//                         }
//                       });
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:umltodart/constants.dart';
import 'package:umltodart/models/shape.dart';

import '../commend.dart';
import 'compenents/side_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Container test = Container();
  Offset offset = Offset.zero;
  List<Shape> shapes = [];
  ScrollController _scrollControllerV = ScrollController();
  ScrollController _scrollControllerH = ScrollController();
  double height =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height -
          55;
  double width =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width -
          100;
  CommandHistory _commandHistory = CommandHistory();

  @override
  void initState() {
    super.initState();
    _scrollControllerV.addListener(() {
      if (_scrollControllerV.position.atEdge) {
        setState(() {
          height += 50;
        });
      }
    });
    _scrollControllerH.addListener(() {
      if (_scrollControllerH.position.atEdge) {
        setState(() {
          width += 50;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: kMainColor,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _commandHistory.undo();
                });
              },
              icon: const Icon(Icons.undo_sharp)),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.play_arrow_sharp)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.redo_sharp)),
        ],
      ),
      body: Row(
        children: [
          SizedBox(
              width: 200,
              height: MediaQuery.of(context).size.height,
              child: SideBar()),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollControllerH,
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                controller: _scrollControllerV,
                child: SizedBox(
                  width: width,
                  height: height,
                  child: GridPaper(
                    child: DragTarget<Shape>(
                      builder: (context, _, __) {
                        return Stack(
                            children: shapes.map((e) {
                          return Positioned(
                            left: e.xPos,
                            top: e.yPos,
                            child: Draggable<Shape>(
                              data: e,
                              feedback: e.build(isPlaced: true),
                              child: e.build(isPlaced: true),
                            ),
                          );
                        }).toList());
                      },
                      onAcceptWithDetails: (details) {
                        setState(() {
                          Shape shape = details.data;
                          if (!shapes.contains(shape)) {
                            shape.setPosition(details.offset.dx - 200,
                                details.offset.dy - 46);
                            var command =
                                AddShapeCommend(shapes: shapes, shape: shape);
                            command.execute();
                            _commandHistory.add(command);
                            return;
                          }
                          var command = EditShapePosCommend(
                              shape: shape,
                              xPos: details.offset.dx - 200,
                              yPos: details.offset.dy - 46);
                          command.execute();
                          _commandHistory.add(command);
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
