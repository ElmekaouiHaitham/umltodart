import 'field.dart';

class Method {
  String name;
  String returnType;
  List<Field> parameters;
  Method(
      {required this.name, required this.returnType, required this.parameters});

  @override
  String toString() {
    return "$name(${argsToString()}): $returnType";
  }

  String argsToString() {
    String result = "";
    parameters.forEach((element) {
      result += element.toString() + ",";
    });
    return result;
  }
}
