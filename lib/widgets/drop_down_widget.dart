import 'package:flutter/material.dart';

class DropDownWidget extends StatefulWidget {

  final String hintText;
  final IconData icon;
  String selectedValue;
  final FormFieldValidator validator;
  final List<String> dropdownItems;
  final Size size;
  final Key formKey;
  final Function(String) onValueChanged;

  DropDownWidget({
    super.key,
    required this.selectedValue,
    required this.dropdownItems,
    required this.size,
    required this.formKey,
    required this.hintText,
    required this.icon,
    required this.validator,
    required this.onValueChanged,
  });

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
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
          child: DropdownButtonFormField<String>(
            validator: widget.validator,
            value: widget.selectedValue,
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Color(0xff7B6F72),
            ),
            iconSize: 30,
            elevation: 10,
            style: const TextStyle(
              color: Color(0xffADA4A5),
              fontSize: 15,
            ),
            onChanged: (String? newValue) {
              setState(() {
                widget.selectedValue = newValue!;
                widget.onValueChanged(newValue);
              });
            },
            dropdownColor: Colors.indigo,
            items: widget.dropdownItems.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xffADA4A5),
                  ),
                ),
              );
            }).toList(),
            decoration: InputDecoration(
              errorStyle: const TextStyle(height: 0),
              hintStyle: const TextStyle(
                color: Color(0xffADA4A5),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(
                top: widget.size.height * 0.006,
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
