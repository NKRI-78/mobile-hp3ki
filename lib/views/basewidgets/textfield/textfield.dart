import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(this);
  }
}

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String emptyWarning;
  final bool isPrefixIcon; 
  final Widget? prefixIcon;
  final bool isSuffixIcon;
  final Widget? suffixIcon;
  final String? labelText;
  final Widget? label;
  final bool? alignLabelWithHint;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final TextInputType textInputType;
  final int maxLines;
  final Function? onChange;
  final bool? isDatePicker;
  final bool? isProvince;
  final bool? isCity;
  final bool? isBloodType;
  final FocusNode focusNode;
  final FocusNode? nextNode;
  final TextInputAction textInputAction;
  final Color counterColor;
  final bool isPhoneNumber;
  final bool isEmail;
  final bool isPassword;
  final bool isBorder;
  final bool isBorderRadius;
  final bool readOnly;
  final bool isEnabled;
  final bool isWhiteBackground;
  final int? maxLength;

  const CustomTextField({
    Key? key, 
    required this.controller,
    this.isPrefixIcon = false,
    this.prefixIcon,
    this.isSuffixIcon = false,
    this.suffixIcon,
    required this.hintText,
    this.alignLabelWithHint = false,
    this.labelText,
    this.label = const SizedBox(),
    this.floatingLabelBehavior = FloatingLabelBehavior.always,
    required this.textInputType,
    this.counterColor = ColorResources.white,
    this.onChange,
    this.isDatePicker,
    this.isCity,
    this.isProvince,
    this.isBloodType = false,
    required this.focusNode,
    required this.emptyWarning,
    this.nextNode,
    required this.textInputAction,
    this.maxLines = 1,
    this.isEmail = false,
    this.isPassword = false,
    this.isBorder = true,
    this.isBorderRadius = false,
    this.readOnly = false,
    this.isEnabled = true,
    this.maxLength,
    this.isPhoneNumber = false,
    this.isWhiteBackground = true,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;

  void toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(context) {
    return TextFormField(
      controller: widget.controller,
      maxLines: widget.maxLines,
      focusNode: widget.focusNode,
      keyboardType: widget.textInputType,
      maxLength: widget.maxLength,
      readOnly: widget.readOnly,
      validator: (value) {
        if (value == null || value.isEmpty) {
          widget.focusNode.requestFocus();
          return widget.emptyWarning;
        }
        if (widget.isPassword) {
          if(value.length < 8) {
            widget.focusNode.requestFocus();
            return "Password minimal 8 digit";
          }
        }
        if (widget.hintText == "Nomor Telepon") {
          if(value.length < 10) {
            widget.focusNode.requestFocus();
            return "Nomor Telepon minimal 10 digit";
          }
        }
        return null;
      },
      textCapitalization: widget.isEmail == true || widget.isPassword == true 
        ? TextCapitalization.none
        : widget.isBloodType == true
          ? TextCapitalization.characters
          : TextCapitalization.sentences,
      enableInteractiveSelection: true,
      enabled: widget.isEnabled,
      textInputAction: widget.textInputAction,
      obscureText: widget.isPassword 
      ? obscureText 
      : false,
      style: poppinsRegular.copyWith(
        fontSize: Dimensions.fontSizeLarge,
        color: ColorResources.black
      ),
      onFieldSubmitted: (String v) {
        setState(() {
          widget.textInputAction == TextInputAction.done
            ? FocusScope.of(context).consumeKeyboardToken()
            : FocusScope.of(context).requestFocus(widget.nextNode);
        });
      },
      inputFormatters: widget.hintText == "Nomor Telepon"
        ? [
            FilteringTextInputFormatter.singleLineFormatter,
            FilteringTextInputFormatter.digitsOnly,
          ]
        : widget.isEmail
          ? [
              FilteringTextInputFormatter.singleLineFormatter,
            ]
          : [
              FilteringTextInputFormatter.singleLineFormatter,
              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9 ]')),
            ],
      decoration: InputDecoration(
        fillColor: ColorResources.transparent,
        filled: true,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            width: 3.0,
            color: ColorResources.hintColor,
          )
        ),
        prefixIcon: widget.isPrefixIcon 
        ? widget.prefixIcon 
        : null,
        suffixIcon: widget.isSuffixIcon
        ? widget.isPassword 
          ? IconButton(
              onPressed: toggle,
              icon: Icon(obscureText
                ? Icons.visibility_off
                : Icons.visibility,
                color: ColorResources.grey,
                size: 18.0,
              ),
            )
          : widget.suffixIcon
        : null,
        counterStyle: poppinsRegular.copyWith(
          color: ColorResources.hintColor,
          fontSize: Dimensions.fontSizeLarge
        ),
        floatingLabelBehavior: widget.floatingLabelBehavior,
        contentPadding: const EdgeInsets.only(bottom: 10.0),
        hintText: widget.hintText,
        hintStyle: poppinsRegular.copyWith(
          color: Colors.grey, 
          fontSize: Dimensions.fontSizeLarge,
          fontWeight: FontWeight.w500,
        ),
        label: widget.label,
        labelStyle: poppinsRegular.copyWith(
          color: Colors.grey,
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}