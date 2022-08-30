import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isDown = false;
  double x = 0.0;
  double y = 0.0;
  int? targetId;
  Map<int, Map<String, double>> pathList = {
    1: {"x": 100, "y": 100, "r": 50, "color": 0},
    2: {"x": 200, "y": 200, "r": 50, "color": 1},
    3: {"x": 300, "y": 300, "r": 50, "color": 2},
  };
  // util function
  bool isInObject(Map<String, double> data, double dx, double dy) {
    Path _tempPath = Path()
      ..addOval(Rect.fromCircle(
          center: Offset(data['x']!, data['y']!), radius: data['r']!));
    return _tempPath.contains(Offset(dx, dy));
  }

// event handler
  void _down(DragStartDetails details) {
    setState(() {
      isDown = true;
      x = details.localPosition.dx;
      y = details.localPosition.dy;
    });
  }

  void _up() {
    setState(() {
      isDown = false;
      targetId = null;
    });
  }

  void _move(DragUpdateDetails details) {
    if (isDown) {
      setState(() {
        x += details.delta.dx;
        y += details.delta.dy;
        targetId ??= pathList.keys
            .firstWhereOrNull((id) => isInObject(pathList[id]!, x, y));
        if (targetId != null) {
          pathList = {
            ...pathList,
            targetId!: {...pathList[targetId!]!, 'x': x, 'y': y}
          };
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: GestureDetector(
          onPanStart: (details) {
            print(details);
            _down(details);
          },
          onPanEnd: (details) {
            _up();
          },
          onPanUpdate: (details) {
            _move(details);
          },
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.grey,
              child: CustomPaint(
                foregroundPainter:
                    ShapePainter(down: isDown, x: x, y: y, pathList: pathList),
                size: Size(MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height),
              )),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

class ShapePainter extends CustomPainter {
  final colors = [Colors.red, Colors.yellow, Colors.lightBlue];
  Path path = Path();
  Paint _paint = Paint()
    ..color = Colors.red
    ..strokeWidth = 5
    ..strokeCap = StrokeCap.round;

  final bool down;
  final double x;
  final double y;
  Map<int, Map<String, double>> pathList;
  ShapePainter({
    required this.down,
    required this.x,
    required this.y,
    required this.pathList,
  });
  @override
  void paint(Canvas canvas, Size size) {
    for (var pathData in pathList.values) {
      _paint = _paint..color = colors[pathData['color']! as int];
      path = Path()
        ..addOval(Rect.fromCircle(
            center: Offset(pathData['x']!, pathData['y']!),
            radius: pathData['r']!));
      canvas.drawPath(path, _paint);
    }
  }

  @override
  bool shouldRepaint(ShapePainter oldDelegate) => down;
}
