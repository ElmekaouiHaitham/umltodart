import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import '../constants.dart';
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

class ShapeContainer extends StatefulWidget {
  final Shape shape;
  final Function() onDelete;
  const ShapeContainer({Key? key, required this.shape, required this.onDelete})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _ShapeContainerState();
}

class _ShapeContainerState extends State<ShapeContainer> {
  @override
  Widget build(BuildContext context) {
    var shape = widget.shape;
    return Positioned(
      left: shape.xPos,
      top: shape.yPos,
      child: Column(children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                shape.remove(setState);
              },
              child: const Icon(Icons.remove),
            ),
            GestureDetector(
              onTap: () {
                shape.edit(setState);
              },
              child: const Icon(Icons.edit),
            ),
            GestureDetector(
              onTap: widget.onDelete,
              child: const Icon(Icons.delete, color: Colors.red),
            ),
            GestureDetector(
              child: Icon(Icons.add),
              onTap: () {
                shape.add(setState);
              },
            ),
          ],
        ),
        Draggable<Shape>(
          data: shape,
          feedback: shape.build(isPlaced: true),
          child: shape.build(isPlaced: true),
        ),
      ]),
    );
  }
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
        width: 200,
        // color: Colors.blue,
        decoration:
            BoxDecoration(border: Border.all(color: Colors.white, width: 2)),
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
                padding: EdgeInsets.all(kDefaultPadding),
                child: Column(
                  children: fields
                      .map(
                        (f) => Text(f.toString()),
                      )
                      .toList(),
                )),
            const Divider(thickness: 2, color: Colors.white),
            Padding(
                padding: EdgeInsets.all(kDefaultPadding),
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
              child: Text("field")),
          ElevatedButton(
              onPressed: () {
                Get.back();
                addMethod(setState);
              },
              child: Text("method")),
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
            SizedBox(
              height: kDefaultInputHeight,
              width: kDefaultInputWidth,
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "method's name",
                  contentPadding: EdgeInsets.all(kDefaultPadding),
                ),
              ),
            ),
            // args section
            StatefulBuilder(builder: (context, setState) {
              return Column(
                children: [
                  Container(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              if (argNamesController.length > 0) {
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
                            icon: Icon(Icons.add),
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
                  ),
                  Divider(
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
                                SizedBox(
                                  height: kDefaultInputHeight,
                                  width: kDefaultInputWidth,
                                  child: TextField(
                                    controller: argNamesController[index],
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "arg's name",
                                      contentPadding:
                                          EdgeInsets.all(kDefaultPadding),
                                    ),
                                  ),
                                ),
                                const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: kSmallPadding),
                                    child: Text(":")),
                                SizedBox(
                                  height: kDefaultInputHeight,
                                  width: kDefaultInputWidth,
                                  child: TextField(
                                    controller: argTypeController[index],
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "arg's type",
                                      contentPadding:
                                          EdgeInsets.all(kDefaultPadding),
                                    ),
                                  ),
                                ),
                              ]),
                              const SizedBox(height: kSmallPadding),
                            ],
                          )),
                ],
              );
            }),
            // return type section
            SizedBox(
              height: kDefaultInputHeight,
              width: kDefaultInputWidth,
              child: TextField(
                controller: returnTypeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "method's return type",
                  contentPadding: EdgeInsets.all(kDefaultPadding),
                ),
              ),
            ),
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
            child: const Text("done"))
      ],
    ));
  }

  void addField(setState) {
    final TextEditingController fieldNameController = TextEditingController();
    final TextEditingController fieldTypeController = TextEditingController();
    Get.dialog(AlertDialog(
      content: Row(children: [
        SizedBox(
          height: kDefaultInputHeight,
          width: kDefaultInputWidth,
          child: TextField(
            controller: fieldNameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "fields's name",
              contentPadding: EdgeInsets.all(kDefaultPadding),
            ),
          ),
        ),
        const Padding(
            padding: EdgeInsets.symmetric(horizontal: kSmallPadding),
            child: Text(":")),
        SizedBox(
          height: kDefaultInputHeight,
          width: kDefaultInputWidth,
          child: TextField(
            controller: fieldTypeController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "fields's type",
              contentPadding: EdgeInsets.all(kDefaultPadding),
            ),
          ),
        ),
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
            child: const Text("done"))
      ],
    ));
  }

  @override
  void edit(setState) {}

  @override
  void remove(setState) {
    // TODO: implement remove
  }
}
