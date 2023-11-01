import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditTextFormFieldNumberKeyboardWidget extends StatefulWidget {

  final String hintText;
  final IconData icon;
  final Size size;
  final FormFieldValidator validator;
  final Key formKey;
  final bool allowNegative;
  final controller;

  const EditTextFormFieldNumberKeyboardWidget({
    super.key,
    required this.hintText,
    required this.icon,
    required this.size,
    required this.validator,
    required this.formKey,
    required this.controller,
    required this.allowNegative,
  });

  @override
  State<EditTextFormFieldNumberKeyboardWidget> createState() => _EditTextFormFieldNumberKeyboardWidgetState();
}

class _EditTextFormFieldNumberKeyboardWidgetState extends State<EditTextFormFieldNumberKeyboardWidget> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: widget.size.height * 0.025),
      child: Container(
        width: widget.size.width * 0.9,
        height: widget.size.height * 0.05,
        decoration: const BoxDecoration(
          color: Color(0xff151f2c),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Form(
          key: widget.formKey,
          child: TextFormField(
            enableSuggestions: false,
            keyboardType: TextInputType.numberWithOptions(signed: widget.allowNegative, decimal: true),
            inputFormatters: <TextInputFormatter>[
              if (widget.allowNegative)
                FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d{0,2}'))
              else
                FilteringTextInputFormatter.allow(RegExp(r'^-?\d+\.?\d{0,2}'))
            ],
            controller: widget.controller,
            style: const TextStyle(
              color: Color(0xffADA4A5),
            ),
            onChanged: (value) {
              setState(() {

              });
            },
            validator: widget.validator,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              errorStyle: const TextStyle(height: 0),
              hintStyle: const TextStyle(
                color: Color(0xffADA4A5),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(
                top: widget.size.height * 0.012,
              ),
              hintText: widget.hintText,
              prefixIcon: Padding(
                padding: EdgeInsets.only(
                  top: widget.size.height * 0.005,
                ),
                child: Icon(
                  widget.icon,
                  color: const Color(0xff7B6F72),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
