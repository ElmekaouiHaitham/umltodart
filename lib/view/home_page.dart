import 'package:flutter/material.dart';
import 'package:umltodart/utils/constants.dart';
import 'package:umltodart/models/shape.dart';

import '../utils/command.dart';
import 'components/my_scroll_view.dart';
import 'components/shape_container.dart';
import 'components/side_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Container test = Container();
  Offset offset = Offset.zero;
  List<Shape> shapes = [];
  final ScrollController _scrollControllerV = ScrollController();
  final ScrollController _scrollControllerH = ScrollController();
  double height =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height -
          55;
  double width =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width -
          100;
  final CommandHistory _commandHistory = CommandHistory();

  @override
  void initState() {
    super.initState();
    // increase the size when never the user gets to the edge
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
        // run and undo
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
        ],
      ),
      body: Row(
        children: [
          // side bar
          // ignoring because we want it to build new instance every time
          // ignore: prefer_const_constructors
          SideBar(),
          // body
          MyScrollView(
            scrollControllerH: _scrollControllerH,
            scrollControllerV: _scrollControllerV,
            width: width,
            height: height,
            child: GridPaper(
              child: DragTarget<Shape>(
                builder: (context, _, __) {
                  return Stack(
                      children: shapes.map((e) {
                    return ShapeContainer(
                      onShapeDelete: () {
                        setState(() {
                          var command =
                              RemoveShapeCommand(shapes: shapes, shape: e);
                          command.execute();
                          _commandHistory.add(command);
                        });
                      },
                      shape: e,
                    );
                  }).toList());
                },
                onAcceptWithDetails: onAccept,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onAccept(DragTargetDetails<Shape> details) {
    setState(() {
      Shape shape = details.data;
      double xPos = details.offset.dx - 200 + _scrollControllerH.offset;
      double yPos = details.offset.dy - 56 + _scrollControllerV.offset;
      // if the shape is dragged from side_bare
      if (!shapes.contains(shape)) {
        shape.setPosition(xPos, yPos);
        var command = AddShapeCommand(shapes: shapes, shape: shape);
        _executeCommand(command);
        return;
      }
      var command = EditShapePosCommand(shape: shape, xPos: xPos, yPos: yPos);
      _executeCommand(command);
    });
  }

  void _executeCommand(Command command) {
    command.execute();
    _commandHistory.add(command);
  }
}
