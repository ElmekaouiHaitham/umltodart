import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import '../models/field.dart';
import '../models/method.dart';
import '../utils/constants.dart';
import '../view/components/input_field.dart';

abstract class ShapeController extends GetxController {
  double xPos;
  double yPos;
  void setPosition(x, y) {
    xPos = x;
    yPos = y;
  }

  ShapeController(this.xPos, this.yPos);

  void remove();

  void edit();

  void add();
}

class ClassController extends ShapeController {
  ClassController(super.xPos, super.yPos);

  RxList fields = [].obs;
  RxList methods = [].obs;

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

  void addMethod() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController returnTypeController = TextEditingController();
    final List<TextEditingController> argNamesController = [];
    final List<TextEditingController> argTypeController = [];
    Get.dialog(_buildMethodDialog(nameController, argNamesController, argTypeController, returnTypeController));
  }

  AlertDialog _buildMethodDialog(TextEditingController nameController, List<TextEditingController> argNamesController, List<TextEditingController> argTypeController, TextEditingController returnTypeController) {
    return AlertDialog(
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
            _addMethod(argNamesController, argTypeController, nameController, returnTypeController);
          },
          child: const Text('done'))
    ],
  );
  }

  void _addMethod(List<TextEditingController> argNamesController, List<TextEditingController> argTypeController, TextEditingController nameController, TextEditingController returnTypeController) {
    List<Field> fields2 = [];
    for (int i = 0; i < argNamesController.length; i++) {
      fields2.add(Field(
          name: argNamesController[i].text,
          type: argTypeController[i].text));
    }
    methods.add(Method(
        name: nameController.text,
        returnType: returnTypeController.text,
        parameters: fields2));
    Get.back();
  }

  void addField() {
    final TextEditingController fieldNameController = TextEditingController();
    final TextEditingController fieldTypeController = TextEditingController();
    Get.dialog(_buildFieldDialog(fieldNameController, fieldTypeController));
  }

  AlertDialog _buildFieldDialog(TextEditingController fieldNameController, TextEditingController fieldTypeController) {
    return AlertDialog(
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
            _addField(fieldNameController, fieldTypeController);
          },
          child: const Text('done'))
    ],
  );
  }

  void _addField(TextEditingController fieldNameController, TextEditingController fieldTypeController) {
    fields.add(Field(
        name: fieldNameController.text,
        type: fieldTypeController.text));
    Get.back();
  }

  @override
  void edit() {
    // TODO: implement edit
  }

  @override
  void remove() {
    // TODO: implement remove
  }
}
