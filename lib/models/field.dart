import '../utils/constants.dart';

class Field {
  String name;
  String type;
  Field({required this.name, required this.type});

  @override
  String toString() {
    return '$name: $type';
  }

  String buildCode() {
    return '${tabs(1)}$type $name;\n';
  }
}
