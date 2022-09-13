import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import '../models/field.dart';
import '../models/method.dart';
import '../utils/command.dart';
import '../utils/constants.dart';
import '../view/components/input_field.dart';
import '../view/components/links.dart';
import '../view/components/shape.dart';

abstract class ShapeController extends GetxController {
  double xPos;
  double yPos;

  List<LinkData> connections = [];

  void setPosition(x, y) {
    xPos = x;
    yPos = y;
  }

  ShapeController(this.xPos, this.yPos);

  String get name;

  void remove(element);

  void edit(element);

  void add();

  String buildCode();
}

class ClassController extends ShapeController {
  ClassController(super.xPos, super.yPos);
  RxList fields = [].obs;
  RxList methods = [].obs;
  final TextEditingController titleController = TextEditingController();

  @override
  void add() {
    Get.dialog(AlertDialog(
      content: FittedBox(
        child: Column(children: [
          ElevatedButton(
              onPressed: () {
                Get.back();
                addField();
              },
              child: const Text('field')),
          ElevatedButton(
              onPressed: () {
                Get.back();
                addMethod();
              },
              child: const Text('method')),
        ]),
      ),
    ));
  }

  Future<void> addMethod() async {
    Method method = await _methodDialog();
    var command = AddElementCommand(element: method, elements: methods);
    _executeCommand(command);
  }

  Future<Method> _methodDialog(
      {name = '', argsNames, argsTypes, returnType = ''}) async {
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController returnTypeController =
        TextEditingController(text: returnType);
    List<TextEditingController> argNamesController = [];
    List<TextEditingController> argTypeController = [];
    // inti the controllers
    if (argsNames != null) {
      for (int i = 0; i < argsNames.length; i++) {
        argNamesController.add(TextEditingController(text: argsNames[i]));
        argTypeController.add(TextEditingController(text: argsTypes[i]));
      }
    }
    await Get.dialog(AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            // name section
            MyInputField(
                nameController: nameController, hintText: "method's name"),
            // args section
            StatefulBuilder(builder: (context, setState) {
              return Column(
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (argNamesController.isNotEmpty) {
                              setState(() {
                                argNamesController.removeLast();
                              });
                            }
                          },
                        ),
                        Text(
                          '${argNamesController.length}',
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              argNamesController.add(TextEditingController());
                              argTypeController.add(TextEditingController());
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                  ...List.generate(
                      argNamesController.length,
                      (index) => Column(
                            children: [
                              Row(children: [
                                // args' name
                                MyInputField(
                                    nameController: argNamesController[index],
                                    hintText: "arg's name"),
                                // the ":"
                                const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: kSmallPadding),
                                    child: Text(':')),
                                // arg's type
                                MyInputField(
                                    nameController: argTypeController[index],
                                    hintText: "arg's type"),
                              ]),
                              const SizedBox(height: kSmallPadding),
                            ],
                          )),
                ],
              );
            }),
            // return type section
            MyInputField(
                nameController: returnTypeController,
                hintText: "method's return type"),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('done'))
      ],
    ));
    List<Field> fields2 = [];
    for (int i = 0; i < argNamesController.length; i++) {
      fields2.add(Field(
          name: argNamesController[i].text, type: argTypeController[i].text));
    }
    return Method(
        name: nameController.text,
        returnType: returnTypeController.text,
        parameters: fields2);
  }

  Future<void> addField() async {
    Field field = await _fieldDialog();
    var command = AddElementCommand(element: field, elements: fields);
    _executeCommand(command);
  }

  Future<Field> _fieldDialog({fieldName = '', fieldType = ''}) async {
    TextEditingController fieldNameController =
        TextEditingController(text: fieldName);
    TextEditingController fieldTypeController =
        TextEditingController(text: fieldType);
    await Get.dialog(AlertDialog(
      content: Row(children: [
        MyInputField(
            nameController: fieldNameController, hintText: "field's name"),
        const Padding(
            padding: EdgeInsets.symmetric(horizontal: kSmallPadding),
            child: Text(':')),
        MyInputField(
            nameController: fieldTypeController, hintText: "field's type")
      ]),
      actions: [
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('done'))
      ],
    ));
    return Field(
        name: fieldNameController.text, type: fieldTypeController.text);
  }

  @override
  Future<void> edit(element) async {
    if (fields.contains(element)) {
      Field field =
          await _fieldDialog(fieldName: element.name, fieldType: element.type);
      var command = EditElementCommand(
          oldElement: element, newElement: field, elements: fields);
      _executeCommand(command);
    }
    if (methods.contains(element)) {
      Method method = await _methodDialog(
          name: element.name,
          returnType: element.returnType,
          argsNames: element.parameters.map((f) => f.name).toList(),
          argsTypes: element.parameters.map((f) => f.type).toList());
      var command = EditElementCommand(
          oldElement: element, newElement: method, elements: methods);
      _executeCommand(command);
    }
  }

  @override
  void remove(element) {
    if (fields.contains(element)) {
      var command = RemoveElementCommand(element: element, elements: fields);
      _executeCommand(command);
    }
    if (methods.contains(element)) {
      var command = RemoveElementCommand(element: element, elements: methods);
      _executeCommand(command);
    }
  }

  void _executeCommand(Command command) {
    command.execute();
    CommandHistory().add(command);
  }

  @override
  String buildCode() {
    Shape? inherited = _checkGeneralization();
    List<Shape> compositions = _checkComposition();
    return '${_buildName(inherited)} {\n${_buildFields(compositions)}\n${_buildConstructor()}\n${buildMethods()}\n}';
  }

  String _buildConstructor() {
    if (fields.isEmpty) {
      return '';
    }
    String content = '';
    for (var field in fields) {
      if (field.type[field.type.length - 1] != '?') {
        content += 'required ';
      }
      content += 'this.${field.name}, ';
    }
    return '${tabs(2)}$name({$content});';
  }

  String _buildFields(List<Shape> compositions) {
    String result = '';
    for (var composition in compositions) {
      fields.add(Field(
          name: composition.controller.name.toLowerCase(),
          type: composition.controller.name));
    }
    for (var field in fields) {
      result += field.buildCode();
    }
    return result;
  }

  String buildMethods() {
    String result = '';
    for (var method in methods) {
      result += method.buildCode();
    }
    return result;
  }

  @override
  String get name => titleController.text;

  set name(String name) => titleController.text = name;

  Shape? _checkGeneralization() {
    for (var connection in connections) {
      if (connection.linkType == LinkType.generalizationLink) {
        return connection.targetShape;
      }
    }
    return null;
  }

  List<Shape> _checkComposition() {
    List<Shape> compositions = [];
    for (var connection in connections) {
      if (connection.linkType == LinkType.composition) {
        compositions.add(connection.targetShape);
      }
    }
    return compositions;
  }

  String _buildName(Shape? inherited) {
    return 'class $name ${inherited != null ? 'extends ${inherited.controller.name}' : ''}';
  }
}
