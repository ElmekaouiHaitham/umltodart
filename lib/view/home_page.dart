import 'package:flutter/material.dart';
import 'package:umltodart/utils/constants.dart';
import 'package:umltodart/view/components/shape.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import '../utils/command.dart';
import 'components/links.dart';
import 'components/my_scroll_view.dart';
import 'components/shape_container.dart';
import 'components/side_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  // this for link tracking

  Shape? sourceShape;

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
              onPressed: _buildCode, icon: const Icon(Icons.play_arrow_sharp)),
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
              child: DragTarget(
                builder: (context, _, __) {
                  return Stack(children: [
                    ...shapes.map((shape) {
                      return ShapeContainer(
                        onShapeDelete: () => onShapeDelete(shape),
                        onLink: () => onShapeLink(shape),
                        child: shape,
                      );
                    }).toList(),
                    ..._showLinks(),
                  ]);
                },
                onAcceptWithDetails: onAccept,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onAccept(DragTargetDetails details) {
    setState(() {
      Shape shape = details.data;
      double xPos =
          details.offset.dx - kSideBarWidth + _scrollControllerH.offset;
      double yPos =
          details.offset.dy - kAppBarHeight + _scrollControllerV.offset;
      // if the shape is dragged from side_bare
      if (!shapes.contains(shape)) {
        _addShape(shape, xPos, yPos);
        return;
      }
      _editShapePos(shape, xPos, yPos);
    });
  }

  void _editShapePos(Shape shape, double xPos, double yPos) {
    var command = EditShapePosCommand(shape: shape, xPos: xPos, yPos: yPos);
    _executeCommand(command);
  }

  void _addShape(Shape shape, double xPos, double yPos) {
    shape.controller.setPosition(xPos, yPos);
    var command = AddShapeCommand(shapes: shapes, shape: shape);
    _executeCommand(command);
  }

  void _executeCommand(Command command) {
    command.execute();
    _commandHistory.add(command);
  }

  onShapeDelete(Shape shape) {
    setState(() {
      var command = RemoveShapeCommand(shapes: shapes, shape: shape);
      _commandHistory.add(command);
      _executeCommand(command);
    });
  }

  void _buildCode() {
    Get.dialog(AlertDialog(
      content: Column(
          children: shapes
              .map((shape) => Container(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    margin: const EdgeInsets.all(kDefaultPadding),
                    color: kCodeBackgroundColor,
                    constraints:
                        const BoxConstraints(minWidth: kCodeBackgroundMinWidth),
                    child: SelectableText(shape.controller.buildCode(),
                        style: const TextStyle(color: Colors.black)),
                  ))
              .toList()),
    ));
  }

  Future<void> onShapeLink(Shape targetShape) async {
    if (sourceShape == null) {
      sourceShape = targetShape;
      Get.snackbar(
          'instructions', 'please select the shape you want to connect to');
    } else {
      LinkType linkType = LinkType.values[0];
      await Get.dialog(AlertDialog(
        content: StatefulBuilder(
          builder: (context, setStateD) => DropdownButton<LinkType>(
            value: linkType,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (LinkType? value) {
              // This is called when the user selects an item.
              setStateD(() {
                linkType = value!;
              });
            },
            items: LinkType.values
                .map(
                  (e) => DropdownMenuItem<LinkType>(
                    value: e,
                    child: Text(e.toString()),
                  ),
                )
                .toList(),
          ),
        ),
      ));
      sourceShape!.controller.connections.add(LinkData(
          linkType: linkType,
          targetShape: targetShape,
          sourceShape: sourceShape!));
      sourceShape = null;
      setState(() {});
    }
  }

  List<Widget> _showLinks() {
    List<Widget> links = [];
    for (var shape in shapes) {
      for (var link in shape.controller.connections) {
        if (shapes.contains(link.targetShape)) {
          links.add(CustomPaint(
            painter: link.linkPainter,
          ));
        }
      }
    }
    return links;
  }
}
