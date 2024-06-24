// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldStoreCstm extends StatefulWidget {
  const TextFormFieldStoreCstm({
    Key? key,
    required this.label,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.controller,
    this.inputFormatters,
    this.onChanged,
    this.maxLines,
    this.minLines,
  }) : super(key: key);

  final String label;

  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final int? maxLines;
  final int? minLines;

  @override
  State<TextFormFieldStoreCstm> createState() => _TextFormFieldStoreCstmState();
}

class _TextFormFieldStoreCstmState extends State<TextFormFieldStoreCstm> {
  String? _errorText = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 50),
          child: TextFormField(
            style: const TextStyle(
              fontSize: 14,
            ),
            validator: (value) {
              setState(() {
                _errorText =
                    widget.validator != null ? widget.validator!(value) : null;
              });
              return _errorText;
            },
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            controller: widget.controller,
            inputFormatters: widget.inputFormatters,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: InputBorder.none,
              //!! Hide the default error message here
              errorStyle: const TextStyle(fontSize: 0, height: 0),
              hintText: widget.label,
              hintStyle: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        if (_errorText?.isNotEmpty ?? false)
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 6),
            child: Text(
              _errorText!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          )
      ],
    );
  }
}

class TextFormFieldStoreAdressCstm extends StatefulWidget {
  const TextFormFieldStoreAdressCstm({
    Key? key,
    required this.label,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.controller,
    this.inputFormatters,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.suffixIcon,
  }) : super(key: key);

  final String label;

  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final bool readOnly;
  final Widget? suffixIcon;

  @override
  State<TextFormFieldStoreAdressCstm> createState() =>
      _TextFormFieldStoreAdressCstmState();
}

class _TextFormFieldStoreAdressCstmState
    extends State<TextFormFieldStoreAdressCstm> {
  String? _errorText = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 50),
          child: TextFormField(
            style: const TextStyle(
              fontSize: 14,
            ),
            onTap: widget.onTap,
            validator: (value) {
              setState(() {
                _errorText =
                    widget.validator != null ? widget.validator!(value) : null;
              });
              return _errorText;
            },
            readOnly: widget.readOnly,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            controller: widget.controller,
            inputFormatters: widget.inputFormatters,
            onChanged: widget.onChanged,
            minLines: 1,
            maxLines: 5,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: InputBorder.none,
              //!! Hide the default error message here
              errorStyle: const TextStyle(fontSize: 0, height: 0),
              hintText: widget.label,
              hintStyle: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              suffixIcon: widget.suffixIcon,
            ),
          ),
        ),
        if (_errorText?.isNotEmpty ?? false)
          Padding(
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 6),
            child: Text(
              _errorText!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          )
      ],
    );
  }
}
