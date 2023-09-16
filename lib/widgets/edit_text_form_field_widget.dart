import 'package:flutter/material.dart';

class EditTextFormFieldWidget extends StatefulWidget {

  final String hintText;
  final IconData icon;
  final bool password;
  final Size size;
  final FormFieldValidator validator;
  final Key formKey;
  final int stringToEdit;
  final controller;

  const EditTextFormFieldWidget({
    super.key,
    required this.hintText,
    required this.icon,
    required this.password,
    required this.size,
    required this.validator,
    required this.formKey,
    required this.stringToEdit,
    required this.controller,
  });

  @override
  State<EditTextFormFieldWidget> createState() => _EditTextFormFieldWidgetState();
}

class _EditTextFormFieldWidgetState extends State<EditTextFormFieldWidget> {

  bool pwVisible = false;

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
            controller: widget.controller,
            style: const TextStyle(
                color: Color(0xffADA4A5)
            ),
            onChanged: (value) {
              setState(() {

              });
            },
            validator: widget.validator,
            textInputAction: TextInputAction.next,
            obscureText: widget.password ? !pwVisible : false,
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
              suffixIcon: widget.password
                  ? Padding(
                padding: EdgeInsets.only(
                  top: widget.size.height * 0.005,
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      pwVisible = !pwVisible;
                    });
                  },
                  child: pwVisible
                      ? const Icon(
                    Icons.visibility_off_outlined,
                    color: Color(0xff7B6F72),
                  )
                      : const Icon(
                    Icons.visibility_outlined,
                    color: Color(0xff7B6F72),
                  ),
                ),
              )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
