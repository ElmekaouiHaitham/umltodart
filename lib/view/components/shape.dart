import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import '../../controllers/shape_controller.dart';
import '../../utils/constants.dart';

abstract class Shape extends StatelessWidget {
  const Shape({Key? key}) : super(key: key);
  ShapeController get controller;
  @override
  Widget build(BuildContext context);
}

class Class extends Shape {
  final TextEditingController _titleController = TextEditingController();

  Class({Key? key}) : super(key: key);

  @override
  final ClassController controller = ClassController(0, 0);
  @override
  Widget build(BuildContext context) {
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
                style: const TextStyle(fontWeight: FontWeight.bold),
                controller: _titleController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "class's name",
                  contentPadding: EdgeInsets.all(kDefaultPadding),
                ),
              ),
              const Divider(thickness: 2, color: Colors.white),
              // fields
              Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Obx(
                    () => (Column(
                      children: controller.fields
                          .map(
                            (f) => Row(
                              // TODO: turn this to a widget
                              children: [
                                IconButton(
                                    onPressed: () => controller.remove(f),
                                    icon: const Icon(Icons.remove)),
                                Text(f.toString()),
                                IconButton(
                                    onPressed: () => controller.edit(f),
                                    icon: const Icon(Icons.edit_rounded)),
                              ],
                            ),
                          )
                          .toList(),
                    )),
                  )),
              const Divider(thickness: 2, color: Colors.white),
              // methods
              Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Obx(
                    () => (Column(
                      children: controller.methods
                          .map(
                            (m) => Row(
                              children: [
                                IconButton(
                                    onPressed: () => controller.remove(m),
                                    icon: const Icon(Icons.remove)),
                                Text(m.toString()),
                                IconButton(
                                    onPressed: () => controller.edit(m),
                                    icon: const Icon(Icons.edit_rounded)),
                              ],
                            ),
                          )
                          .toList(),
                    )),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
