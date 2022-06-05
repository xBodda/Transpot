import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import '../utils/size_config.dart';

class FormError extends StatelessWidget {
  
  const FormError({
    Key? key,
    required this.errors,
  }) : super(key: key);

  final List<String> errors;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(errors.length, (index) => formErrorText(error: errors[index])),
    );
  }

  Row formErrorText({required String error}) {
    return Row(
      children: [
        SizedBox(width: getSuitableScreenWidth(10)),
        Text(error)
      ],
    );
  }
}