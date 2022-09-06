// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:collection';

import '../view/components/shape.dart';

abstract class Command {
  void execute();
  void undo();
}

class AddShapeCommand implements Command {
  Shape shape;
  List<Shape> shapes;
  AddShapeCommand({required this.shape, required this.shapes});

  @override
  void execute() {
    shapes.add(shape);
  }

  @override
  void undo() {
    shapes.remove(shape);
  }
}

class RemoveShapeCommand implements Command {
  Shape shape;
  List<Shape> shapes;
  RemoveShapeCommand({required this.shape, required this.shapes});

  @override
  void execute() {
    shapes.remove(shape);
  }

  @override
  void undo() {
    shapes.add(shape);
  }
}

class EditShapePosCommand implements Command {
  Shape shape;
  late double perviousXPos;
  late double perviousYPos;
  double xPos;
  double yPos;
  EditShapePosCommand({
    required this.shape,
    required this.xPos,
    required this.yPos,
  });

  @override
  void execute() {
    perviousXPos = shape.controller.xPos;
    perviousYPos = shape.controller.yPos;
    shape.controller.setPosition(xPos, yPos);
  }

  @override
  void undo() {
    shape.controller.setPosition(perviousXPos, perviousYPos);
  }
}

class AddElementCommand implements Command {
  final element;
  final elements;

  AddElementCommand({required this.element, required this.elements});
  @override
  void execute() {
    elements.add(element);
  }

  @override
  void undo() {
    elements.remove(element);
  }
}

class RemoveElementCommand implements Command {
  final element;
  final elements;

  RemoveElementCommand({required this.element, required this.elements});
  @override
  void execute() {
    elements.remove(element);
  }

  @override
  void undo() {
    elements.add(element);
  }
}

class EditElementCommand implements Command {
  final oldElement;
  final newElement;
  final elements;

  EditElementCommand(
      {required this.oldElement,
      required this.newElement,
      required this.elements});
  @override
  void execute() {
    elements.remove(oldElement);
    elements.add(newElement);
  }

  @override
  void undo() {
    elements.add(oldElement);
    elements.remove(newElement);
  }
}

class CommandHistory {
  final ListQueue<Command> _commandList = ListQueue<Command>();
  bool get isEmpty => _commandList.isEmpty;

  static final CommandHistory _singleton = CommandHistory._internal();

  factory CommandHistory() {
    return _singleton;
  }

  CommandHistory._internal();

  void add(Command command) {
    _commandList.add(command);
  }

  void undo() {
    if (_commandList.isNotEmpty) {
      var command = _commandList.removeLast();
      command.undo();
    }
  }
}
