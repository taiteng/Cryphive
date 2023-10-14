import 'package:flutter/material.dart';

class DateTimePickerWidget extends StatefulWidget {

  final String hintText;
  final Size size;
  final FormFieldValidator validator;
  final Key formKey;
  final controller;
  final IconData icon;

  const DateTimePickerWidget({
    super.key,
    required this.size,
    required this.hintText,
    required this.validator,
    required this.formKey,
    this.controller,
    required this.icon,
  });

  @override
  State<DateTimePickerWidget> createState() => _DateTimePickerWidgetState();
}

class _DateTimePickerWidgetState extends State<DateTimePickerWidget> {

  DateTime _selectedDateTime = DateTime.now();

  Future<void> _selectDateTime(BuildContext context) async {
    DateTime? pickedDateTime = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Date and Time'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Date:'),
                subtitle: Text('${_selectedDateTime.toLocal()}'.split(' ')[0]),
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDateTime,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null && date != _selectedDateTime) {
                    setState(() {
                      _selectedDateTime = DateTime(date.year, date.month, date.day, _selectedDateTime.hour, _selectedDateTime.minute);
                    });
                  }
                },
              ),
              ListTile(
                title: const Text('Time:'),
                subtitle: Text('${_selectedDateTime.toLocal()}'.split(' ')[1].substring(0, 5)),
                onTap: () async {
                  TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
                  );
                  if (time != null) {
                    setState(() {
                      _selectedDateTime = DateTime(_selectedDateTime.year, _selectedDateTime.month, _selectedDateTime.day, time.hour, time.minute);
                    });
                  }
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(_selectedDateTime);
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
          ],
        );
      },
    );

    if (pickedDateTime != null) {
      setState(() {
        _selectedDateTime = pickedDateTime;
        widget.controller.text = _selectedDateTime.toString();
      });
    }
  }

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
            readOnly: true,
            onTap: () {
              _selectDateTime(context);
            },
            controller: widget.controller,
            style: const TextStyle(
              color: Color(0xffADA4A5),
            ),
            onChanged: (value) {
              setState(() {

              });
            },
            validator: widget.validator,
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
