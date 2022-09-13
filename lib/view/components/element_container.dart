import 'package:flutter/material.dart';

class ElementContainer extends StatelessWidget {
  final String text;
  final void Function()? onRemove;
  final void Function()? onEdit;
  const ElementContainer(
      {Key? key, required this.text, this.onRemove, this.onEdit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        children: [
          IconButton(onPressed: onRemove, icon: const Icon(Icons.remove)),
          Text(text),
          IconButton(onPressed: onEdit, icon: const Icon(Icons.edit_rounded)),
        ],
      ),
    );
  }
}
