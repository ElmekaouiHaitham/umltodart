import 'dart:math';

import 'package:flutter/material.dart';

class VectorUtils {
  static Offset getDirectionVector(Offset point1, Offset point2) {
    return point2 - point1;
  }

  static Offset getPerpendicularVector(Offset point11, Offset point2) {
    return Offset((point2.dy - point11.dy), -(point2.dx - point11.dx));
  }

  static Offset getPerpendicularVectorToVector(
    Offset vector, [
    bool clockwise = true,
  ]) {
    return clockwise
        ? Offset(-vector.dy, vector.dx)
        : Offset(vector.dy, -vector.dx);
  }

  static Offset normalizeVector(Offset vector) {
    return vector.distance == 0.0 ? vector : vector / vector.distance;
  }

  static Offset getShorterLineStart(
      Offset point1, Offset point2, double shortening) {
    return point1 +
        normalizeVector(getDirectionVector(point1, point2)) * shortening;
  }

  static Offset getShorterLineEnd(
      Offset point1, Offset point2, double shortening) {
    return point2 -
        normalizeVector(getDirectionVector(point1, point2)) * shortening;
  }

  static Path getRectAroundLine(Offset point1, Offset point2, rectWidth) {
    Path path = Path();
    Offset pnsv = VectorUtils.normalizeVector(
            VectorUtils.getPerpendicularVector(point1, point2)) *
        rectWidth;

    // rect around line
    path.moveTo(point1.dx + pnsv.dx, point1.dy + pnsv.dy);
    path.lineTo(point2.dx + pnsv.dx, point2.dy + pnsv.dy);
    path.lineTo(point2.dx - pnsv.dx, point2.dy - pnsv.dy);
    path.lineTo(point1.dx - pnsv.dx, point1.dy - pnsv.dy);
    path.close();

    return path;
  }

  static Offset getPositionByLength(
      Offset point1, Offset point2, double distance) {
    Offset diff = point2 - point1;
    double slope = diff.dy / diff.dx;
    double angle = atan(slope.abs());
    double x = cos(angle) * distance * diff.dx / diff.dx.abs();
    double y = sin(angle) * distance * diff.dy / diff.dy.abs();
    return Offset(x, y);
  }

  static Offset transform(Offset point, double angle) {
    // for testing convert degree to radian
    // angle = angle * pi / 180;
    Offset i = Offset(cos(angle), sin(angle));
    Offset j = Offset(cos(angle + pi / 2), sin(angle + pi / 2));
    return Offset(
        point.dx * i.dx + point.dy * j.dx, point.dx * i.dy + point.dy * j.dy);
  }

  static double rotationAngle(Offset point1, Offset point2) {
    Offset diff = point1 - point2;
    double slope = diff.dy / diff.dx;
    if (diff.dx > 0) {
      return atan(slope) + pi;
    }
    return atan(slope);
  }
}
