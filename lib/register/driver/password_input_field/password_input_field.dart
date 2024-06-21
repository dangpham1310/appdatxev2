import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PasswordInputField extends StatefulWidget {
  final TextEditingController controller;
  final String placeholder;

  PasswordInputField({required this.controller, required this.placeholder});

  @override
  _PasswordInputFieldState createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  List<TextEditingController> textControllers =
      List.generate(6, (index) => TextEditingController());

  @override
  void dispose() {
    for (var controller in textControllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.length == 1) {
      if (index < 5) {
        focusNodes[index + 1].requestFocus();
      } else {
        FocusScope.of(context).unfocus();
      }
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }

    widget.controller.text =
        textControllers.map((controller) => controller.text).join();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return Container(
          width: 40.0,
          height: 40.0,
          child: CupertinoTextField(
            controller: textControllers[index],
            focusNode: focusNodes[index],
            obscureText: true,
            maxLength: 1,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
            ),
            onChanged: (value) => _onChanged(value, index),
          ),
        );
      }),
    );
  }
}
