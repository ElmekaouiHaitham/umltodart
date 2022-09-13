import '../utils/constants.dart';
import 'field.dart';

class Method {
  String name;
  String returnType;
  List<Field> parameters;
  Method(
      {required this.name, required this.returnType, required this.parameters});

  @override
  String toString() {
    return '$name(${argsToString()}): $returnType';
  }

  String argsToString() {
    String result = '';
    for (var element in parameters) {
      result += '$element,';
    }
    return result;
  }

  String buildCode() {
    return '${tabs(1)}$returnType $name(${_buildParms()}){\n${_buildBody()}\n}';
  }

  String _buildParms() {
    String result = '';
    for (var par in parameters) {
      result += '${par.type} ${par.name}, ';
    }
    return result;
  }

  String _buildBody() {
    return '${tabs(2)}//TODO: implement test\n${tabs(2)}throw UnimplementedError();';
  }
}

