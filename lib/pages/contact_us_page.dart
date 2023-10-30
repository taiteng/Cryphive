import 'package:contactus/contactus.dart';
import 'package:flutter/material.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  @override
  Widget build(BuildContext context) {
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
          'CONTACT US',
          style: TextStyle(
            color: Colors.yellowAccent,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ContactUs(
          cardColor: Colors.white,
          textColor: Colors.deepOrange,
          logo: const AssetImage('assets/images/cryphive_word_nobg.png'),
          email: 'taitengchan@gmail.com',
          emailText: 'taitengchan@gmail.com',
          companyName: 'CnS.co',
          companyColor: Colors.orange,
          dividerThickness: 2,
          phoneNumber: '+60143096966',
          phoneNumberText: '+60143096966',
          website: 'https://github.com/taiteng',
          githubUserName: 'ChanTaiTeng',
          linkedinURL: 'https://www.linkedin.com/in/taiteng-chan-4b942021b/',
          tagLine: 'BCTCUN INTI Student',
          taglineColor: Colors.orangeAccent,
          twitterHandle: 'WSugarCTT',
          instagram: 'taitengchan',
          facebookHandle: 'taiteng.chan',
        ),
      ),
    );
  }
}
