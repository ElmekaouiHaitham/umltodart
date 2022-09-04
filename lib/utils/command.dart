import 'dart:collection';

import '../models/shape.dart';

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
