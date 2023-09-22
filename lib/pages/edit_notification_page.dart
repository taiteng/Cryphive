import 'package:flutter/material.dart';

class EditNotificationPage extends StatefulWidget {
  const EditNotificationPage({super.key});

  @override
  State<EditNotificationPage> createState() => _EditNotificationPageState();
}

class _EditNotificationPageState extends State<EditNotificationPage> {
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xff090a13),
      appBar: AppBar(
        elevation: 0.00,
        titleSpacing: 00.0,
        centerTitle: true,
        toolbarHeight: 40,
        toolbarOpacity: 0.8,
        backgroundColor: const Color(0xff151f2c),
        title: const Text(
          'NOTIFICATION',
          style: TextStyle(
            color: Colors.yellowAccent,
          ),
        ),
      ),
    );
  }
}
