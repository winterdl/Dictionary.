import 'package:Dictionary/widgets/border/border_radius.dart';
import 'package:flutter/material.dart';

import '../../widgets/colors/grey_light_color.dart';
import '../../widgets/colors/red_color.dart';

buildTextField({
  String? errorText,
  FocusNode? focusNode,
  required TextEditingController controller,
  required TextInputType textInputType,
  required String hint,
  String? validator(String? val)?,
  onSubmit(String str)?,
}) =>
    TextFormField(
      autovalidateMode: AutovalidateMode.disabled,
      validator: validator,
      focusNode: focusNode,
      onFieldSubmitted: onSubmit,
      decoration: _inputDecoration(errorText: errorText, hint: hint),
      maxLines: 1,
      enableSuggestions: true,
      cursorColor: redColor(),
      style: TextStyle(
        fontSize: 15,
        color: Colors.black,
      ),
      keyboardType: textInputType,
      controller: controller,
    );

_inputDecoration({required String? errorText, required String hint}) =>
    InputDecoration(
        focusedBorder: _outlineInputDecor(redColor()),
        enabledBorder: _outlineInputDecor(greyLightColor()),
        contentPadding: EdgeInsets.only(left: 15),
        hintText: hint,
        hintStyle: TextStyle(color: greyLightColor()),
        focusedErrorBorder: _outlineInputDecor(Colors.red),
        errorBorder: _outlineInputDecor(Colors.red),
        errorStyle: TextStyle(color: Colors.red),
        errorText: errorText);

OutlineInputBorder _outlineInputDecor(Color color) {
  return OutlineInputBorder(
    borderSide: BorderSide(color: color),
    borderRadius: borderRadius(),
  );
}
