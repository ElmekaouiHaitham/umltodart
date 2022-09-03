import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import '../utils/constants.dart';
import '../view/components/input_field.dart';
import 'field.dart';
import 'method.dart';

abstract class Shape {
  double xPos;
  double yPos;
  Widget build({bool isPlaced = false});
  void setPosition(x, y) {
    xPos = x;
    yPos = y;
  }

  Shape(this.xPos, this.yPos);

  void remove(void Function(void Function() fn) setState);

  void edit(void Function(void Function() fn) setState);

  void add(void Function(void Function() fn) setState);
}

class Class extends Shape {
  Class(double xPos, double yPos)
      : super(
          xPos,
          yPos,
        );

  final TextEditingController _titleController = TextEditingController();

  List<Field> fields = [];
  List<Method> methods = [];

  @override
  Widget build({bool isPlaced = false}) {
    return Card(
      child: Container(
        constraints: const BoxConstraints(
            minWidth: kShapeMinWidth, maxWidth: kShapeMaxWidth),
        decoration:
            BoxDecoration(border: Border.all(color: Colors.white, width: 2)),
        child: IntrinsicWidth(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "class's name",
                  contentPadding: EdgeInsets.all(kDefaultPadding),
                ),
                readOnly: !isPlaced,
              ),
              const Divider(thickness: 2, color: Colors.white),
              // fields
              Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Column(
                    children: fields
                        .map(
                          (f) => Text(f.toString()),
                        )
                        .toList(),
                  )),
              const Divider(thickness: 2, color: Colors.white),
              // methods
              Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Column(
                    children: methods
                        .map(
                          (f) => Text(f.toString()),
                        )
                        .toList(),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void add(setState) {
    Get.dialog(AlertDialog(
      content: FittedBox(
        child: Column(children: [
          ElevatedButton(
              onPressed: () {
                Get.back();
                addField(setState);
              },
              child: const Text('field')),
          ElevatedButton(
              onPressed: () {
                Get.back();
                addMethod(setState);
              },
              child: const Text('method')),
        ]),
      ),
    ));
  }

  void addMethod(setState) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController returnTypeController = TextEditingController();
    final List<TextEditingController> argNamesController = [];
    final List<TextEditingController> argTypeController = [];
    Get.dialog(AlertDialog(
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
              setState(() {});
            },
            child: const Text('done'))
      ],
    ));
  }

  void addField(setState) {
    final TextEditingController fieldNameController = TextEditingController();
    final TextEditingController fieldTypeController = TextEditingController();
    Get.dialog(AlertDialog(
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
              fields.add(Field(
                  name: fieldNameController.text,
                  type: fieldTypeController.text));
              Get.back();
              setState(() {});
            },
            child: const Text('done'))
      ],
    ));
  }

  @override
  void edit(setState) {
    // TODO: implement edit
  }

  @override
  void remove(setState) {
    // TODO: implement remove
  }
}
