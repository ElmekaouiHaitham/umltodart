import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/vector_utils.dart';
import 'shape.dart';

class LinkData {
  final Shape sourceShape;
  final Shape targetShape;
  final LinkType linkType;
  late LinkPainter linkPainter;

  LinkData(
      {required this.targetShape,
      required this.linkType,
      required this.sourceShape}) {
    linkPainter = LinkPainter(sourceShape, targetShape, linkType);
  }
}

enum LinkType {
  generalizationLink,
  composition,
}

class GeneralizationLink {
  static Path getArrowPath(Offset point1, Offset point2) {
    Path path = Path();
    double rotationAngle = VectorUtils.rotationAngle(point1, point2);
    // double rotationAngle = 180;
    Offset p1 = VectorUtils.transform(
            const Offset(0, -kArrowLength / 2), rotationAngle) +
        point2;
    Offset p2 =
        VectorUtils.transform(const Offset(kArrowLength, 0), rotationAngle) +
            point2;
    Offset p3 = VectorUtils.transform(
            const Offset(0, kArrowLength / 2), rotationAngle) +
        point2;
    path.moveTo(p1.dx, p1.dy);
    // compute the length of the line that links the two shapes
    path.lineTo(p2.dx, p2.dy);
    path.lineTo(p3.dx, p3.dy);

    path.getBounds();

    path.close();

    return path;
  }
}

class Composition {
  static Path getArrowPath(Offset point1, Offset point2) {
    Path path = Path();
    double rotationAngle = VectorUtils.rotationAngle(point1, point2);
    Offset p1 = VectorUtils.transform(
            const Offset(kArrowLength / 2, kArrowLength / 2), rotationAngle) +
        point2;
    Offset p2 =
        VectorUtils.transform(const Offset(kArrowLength, 0), rotationAngle) +
            point2;
    Offset p3 = VectorUtils.transform(
            const Offset(kArrowLength / 2, -kArrowLength / 2), rotationAngle) +
        point2;
    path.moveTo(point2.dx, point2.dy);
    path.lineTo(p1.dx, p1.dy);
    path.lineTo(p2.dx, p2.dy);
    path.lineTo(p3.dx, p3.dy);
    // path.addRect()
    path.close();
    return path;
  }
}

class LinkPainter extends CustomPainter {
  Shape shape1;
  Shape shape2;
  LinkPainter(this.shape1, this.shape2, this.linkType);
  LinkType linkType;
  Path getArrowTipPath(Offset point1, Offset point2) {
    switch (linkType) {
      case LinkType.generalizationLink:
        return GeneralizationLink.getArrowPath(point1, point2);
      default:
        return Composition.getArrowPath(point1, point2);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    Offset startPoint = getIntersectPoint(shape1, shape2);
    Offset endPoint = getIntersectPoint(shape2, shape1);
    // make Place for the arrow
    endPoint = endPoint +
        VectorUtils.getPositionByLength(startPoint, endPoint, -kArrowLength);
    Paint paint = Paint();
    paint.strokeWidth = 3;
    paint.style = PaintingStyle.fill;
    // 4
    canvas.drawLine(startPoint, endPoint, paint);
    canvas.drawPath(getArrowTipPath(startPoint, endPoint), paint);
  }

  // calculate the point on the border of the shape to connect with another one;
  Offset getIntersectPoint(Shape sourceShape, Shape targetShape) {
    Offset diff = sourceShape.centerPos! - targetShape.centerPos!;
    // calculate the slope of the line from center of first Shape to the center of the second
    double slope = (diff.dy / diff.dx);
    // check if the line is going to intersect with horizontal line (width)
    if (slope.abs() > sourceShape.heightByWidth) {
      int yDir = sourceShape.centerPos!.dy < targetShape.centerPos!.dy ? 1 : -1;
      double y =
          sourceShape.centerPos!.dy + sourceShape.size!.height / 2 * yDir;
      double x =
          ((y - sourceShape.centerPos!.dy) / slope) + sourceShape.centerPos!.dx;
      return Offset(x, y);
    } else {
      int xDir = sourceShape.centerPos!.dx < targetShape.centerPos!.dx ? 1 : -1;
      return Offset(
          sourceShape.centerPos!.dx + xDir * sourceShape.size!.width / 2,
          slope * sourceShape.size!.width / 2 * xDir +
              sourceShape.centerPos!.dy);
    }
  }

  @override
  bool shouldRepaint(LinkPainter oldDelegate) {
    return true;
  }
}

