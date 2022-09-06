import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class MyInputField extends StatelessWidget {
  const MyInputField({
    Key? key,
    required this.nameController,
    required this.hintText,
  }) : super(key: key);

  final TextEditingController nameController;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kDefaultInputHeight,
      width: kDefaultInputWidth,
      child: TextField(
        textInputAction: TextInputAction.next,
        controller: nameController,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: hintText,
          contentPadding: const EdgeInsets.all(kDefaultPadding),
        ),
      ),
    );
  }
}
