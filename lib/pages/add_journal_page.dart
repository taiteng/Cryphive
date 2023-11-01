import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryphive/pages/navigation_page.dart';
import 'package:cryphive/widgets/button_widget.dart';
import 'package:cryphive/widgets/date_time_picker_widget.dart';
import 'package:cryphive/widgets/drop_down_widget.dart';
import 'package:cryphive/widgets/edit_text_form_field_number_keyboard_widget.dart';
import 'package:cryphive/widgets/edit_text_form_field_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AddJournalPage extends StatefulWidget {

  const AddJournalPage({
    super.key,
  });

  @override
  State<AddJournalPage> createState() => _AddJournalPageState();
}

class _AddJournalPageState extends State<AddJournalPage> {

  final User? user = FirebaseAuth.instance.currentUser;

  String actionSelectedValue = 'Buy';
  String timeFrameSelectedValue = '1H';

  final _symbolKey = GlobalKey<FormState>();
  final _actionKey = GlobalKey<FormState>();
  final _timeFrameKey = GlobalKey<FormState>();
  final _strategyKey = GlobalKey<FormState>();
  final _entryPriceKey = GlobalKey<FormState>();
  final _exitPriceKey = GlobalKey<FormState>();
  final _takeProfitKey = GlobalKey<FormState>();
  final _stopLossKey = GlobalKey<FormState>();
  final _profitAndLossKey = GlobalKey<FormState>();
  final _riskRewardRatioKey = GlobalKey<FormState>();
  final _feedbackKey = GlobalKey<FormState>();
  final _feesKey = GlobalKey<FormState>();
  final _entryDateKey = GlobalKey<FormState>();
  final _exitDateKey = GlobalKey<FormState>();

  TextEditingController symbolController = TextEditingController();
  TextEditingController strategyController = TextEditingController();
  TextEditingController entryPriceController = TextEditingController();
  TextEditingController exitPriceController = TextEditingController();
  TextEditingController takeProfitController = TextEditingController();
  TextEditingController stopLossController = TextEditingController();
  TextEditingController profitAndLossController = TextEditingController();
  TextEditingController riskRewardRatioController = TextEditingController();
  TextEditingController feedbackController = TextEditingController();
  TextEditingController feesController = TextEditingController();
  TextEditingController entryDateController = TextEditingController();
  TextEditingController exitDateController = TextEditingController();

  PlatformFile? _pickedFile;
  UploadTask? _uploadTask;
  String? urlDownload;

  Future selectFile() async{
    try{
      final result = await FilePicker.platform.pickFiles();
      if(result == null) return;

      setState(() {
        _pickedFile = result.files.first;
      });
    } catch (error) {
      print(error.toString());
    }
  }

  Future uploadFile() async{
    try{
      final path = 'Journal/${_pickedFile!.name}';
      final file = File(_pickedFile!.path!);

      final ref = FirebaseStorage.instance.ref().child(path);
      setState(() {
        _uploadTask = ref.putFile(file);
      });

      final snapshot = await _uploadTask!.whenComplete(() {});
      urlDownload = await snapshot.ref.getDownloadURL();

      setState(() {
        _uploadTask = null;
      });
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> uploadToFirebase() async{
    try{
      DateTime entryDateTime = DateTime.parse(entryDateController.text);
      Timestamp entryTimestamp = Timestamp.fromDate(entryDateTime);

      DateTime exitDateTime = DateTime.parse(exitDateController.text);
      Timestamp exitTimestamp = Timestamp.fromDate(exitDateTime);

      final journalRef = FirebaseFirestore.instance
          .collection("Users")
          .doc(user?.uid.toString())
          .collection("TradingJournals");

      if(_pickedFile != null){
        await uploadFile();

        await journalRef.add({
          'Action': actionSelectedValue.toString(),
        }).then((DocumentReference docID) async {
          await journalRef.doc(docID.id.toString()).set({
            'Action' : actionSelectedValue.toString(),
            'EntryDate': entryTimestamp,
            'EntryPrice': double.parse(entryPriceController.text.toString()),
            'ExitDate': exitTimestamp,
            'ExitPrice': double.parse(exitPriceController.text.toString()),
            'Feedback': feedbackController.text.toString(),
            'Fees': double.parse(feesController.text.toString()),
            'ImageURL': urlDownload.toString(),
            'JID': docID.id.toString(),
            'ProfitAndLoss': double.parse(profitAndLossController.text.toString()),
            'RiskRewardRatio': double.parse(riskRewardRatioController.text.toString()),
            'StopLoss': double.parse(stopLossController.text.toString()),
            'TakeProfit': double.parse(takeProfitController.text.toString()),
            'Strategy': strategyController.text.toString(),
            'Symbol': symbolController.text.toString(),
            'Timeframe': timeFrameSelectedValue.toString(),
          });
        });
      }
      else{
        await journalRef.add({
          'Action': actionSelectedValue.toString(),
        }).then((DocumentReference docID) async {
          await journalRef.doc(docID.id.toString()).set({
            'Action' : actionSelectedValue.toString(),
            'EntryDate': entryTimestamp,
            'EntryPrice': double.parse(entryPriceController.text.toString()),
            'ExitDate': exitTimestamp,
            'ExitPrice': double.parse(exitPriceController.text.toString()),
            'Feedback': feedbackController.text.toString(),
            'Fees': double.parse(feesController.text.toString()),
            'ImageURL': 'https://www.entrepreneurshipinabox.com/wp-content/uploads/A-Basic-Guide-To-Stock-Trading-1024x682.jpg',
            'JID': docID.id.toString(),
            'ProfitAndLoss': double.parse(profitAndLossController.text.toString()),
            'RiskRewardRatio': double.parse(riskRewardRatioController.text.toString()),
            'StopLoss': double.parse(stopLossController.text.toString()),
            'TakeProfit': double.parse(takeProfitController.text.toString()),
            'Strategy': strategyController.text.toString(),
            'Symbol': symbolController.text.toString(),
            'Timeframe': timeFrameSelectedValue.toString(),
          });
        });
      }

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => NavigationPage(index: 3,)));
    } catch(e) {
      print(e.toString());
    }
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
    stream: _uploadTask?.snapshotEvents,
    builder: (context, snapshot){
      if(snapshot.hasData){
        final data = snapshot.data!;
        double progress = data.bytesTransferred / data.totalBytes;

        return SizedBox(
          height: 50,
          child: Stack(
            fit: StackFit.expand,
            children: [
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.shade200,
                color: Colors.deepOrangeAccent,
              ),
              Center(
                child: Text(
                  '${(100 * progress).round()}%',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      }
      else if(snapshot.connectionState ==  ConnectionState.waiting){
        return const Text('Waiting for Upload');
      }
      else{
        return const Text('');
      }
    },
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    symbolController.dispose();
    strategyController.dispose();
    entryPriceController.dispose();
    exitPriceController.dispose();
    takeProfitController.dispose();
    stopLossController.dispose();
    profitAndLossController.dispose();
    riskRewardRatioController.dispose();
    feedbackController.dispose();
    feesController.dispose();
    entryDateController.dispose();
    exitDateController.dispose();
    super.dispose();
  }

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
          'ADD JOURNAL',
          style: TextStyle(
            color: Colors.yellowAccent,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              EditTextFormFieldWidget(
                hintText: 'Symbol',
                icon: Icons.attach_money_rounded,
                password: false,
                size: size,
                validator: (value) {
                  if (value.length <= 0) {
                    buildSnackError(
                      'Invalid Symbol',
                      context,
                      size,
                    );
                    return '';
                  }
                  return null;
                },
                formKey: _symbolKey,
                controller: symbolController,
              ),

              DropDownWidget(
                selectedValue: actionSelectedValue,
                dropdownItems: const ['Buy', 'Sell'],
                size: size,
                validator: (value) {
                  if (value == null) {
                    buildSnackError(
                      'Invalid Action',
                      context,
                      size,
                    );
                    return '';
                  }
                  return null;
                },
                formKey: _actionKey,
                hintText: 'Action',
                icon: Icons.pending_actions_rounded,
                onValueChanged: (newValue) {
                  setState(() {
                    actionSelectedValue = newValue;
                  });
                },
              ),

              DropDownWidget(
                selectedValue: timeFrameSelectedValue,
                dropdownItems: const ['1m', '3m', '5m', '15m',
                  '30m', '45m', '1H', '2H', '3H', '4H', '6H',
                '12H', '1D', '3D', '1W', '1M', '3M', '6M', '12M'],
                size: size,
                validator: (value) {
                  if (value == null) {
                    buildSnackError(
                      'Invalid Timeframe',
                      context,
                      size,
                    );
                    return '';
                  }
                  return null;
                },
                formKey: _timeFrameKey,
                hintText: 'Timeframe',
                icon: Icons.view_timeline_rounded,
                onValueChanged: (newValue) {
                  setState(() {
                    timeFrameSelectedValue = newValue;
                  });
                },
              ),

              EditTextFormFieldWidget(
                hintText: 'Strategy',
                icon: Icons.lightbulb_circle_rounded,
                password: false,
                size: size,
                validator: (value) {
                  if (value.length <= 0) {
                    buildSnackError(
                      'Invalid Strategy',
                      context,
                      size,
                    );
                    return '';
                  }
                  return null;
                },
                formKey: _strategyKey,
                controller: strategyController,
              ),
              EditTextFormFieldNumberKeyboardWidget(
                hintText: 'Entry Price',
                icon: Icons.trending_up_outlined,
                size: size,
                validator: (value) {
                  if (value.isEmpty) {
                    buildSnackError(
                      'Invalid Entry Price',
                      context,
                      size,
                    );
                    return '';
                  }
                  return null;
                },
                formKey: _entryPriceKey,
                controller: entryPriceController,
                allowNegative: false,
              ),
              EditTextFormFieldNumberKeyboardWidget(
                hintText: 'Exit Price',
                icon: Icons.trending_down_rounded,
                size: size,
                validator: (value) {
                  if (value.isEmpty) {
                    buildSnackError(
                      'Invalid Exit Price',
                      context,
                      size,
                    );
                    return '';
                  }
                  return null;
                },
                formKey: _exitPriceKey,
                controller: exitPriceController,
                allowNegative: false,
              ),
              EditTextFormFieldNumberKeyboardWidget(
                hintText: 'Take Profit',
                icon: Icons.trending_flat_rounded,
                size: size,
                validator: (value) {
                  if (value.isEmpty) {
                    buildSnackError(
                      'Invalid Take Profit',
                      context,
                      size,
                    );
                    return '';
                  }
                  else if(exitPriceController.text != null && entryPriceController.text != null){
                    if (actionSelectedValue == 'Buy'){
                      if(double.parse(value) < double.parse(exitPriceController.text) && double.parse(value) > double.parse(entryPriceController.text)){
                        buildSnackError(
                          'Take Profit lower than Exit Price',
                          context,
                          size,
                        );
                        return '';
                      }
                      else if(double.parse(value) < double.parse(entryPriceController.text)){
                        buildSnackError(
                          'Take Profit lower than Entry Price',
                          context,
                          size,
                        );
                        return '';
                      }
                    }
                    else if (actionSelectedValue == 'Sell'){
                      if(double.parse(value) > double.parse(exitPriceController.text) && double.parse(value) < double.parse(entryPriceController.text)){
                        buildSnackError(
                          'Take Profit higher than Exit Price',
                          context,
                          size,
                        );
                        return '';
                      }
                      else if(double.parse(value) > double.parse(entryPriceController.text)){
                        buildSnackError(
                          'Take Profit higher than Entry Price',
                          context,
                          size,
                        );
                        return '';
                      }
                    }
                  }
                  return null;
                },
                formKey: _takeProfitKey,
                controller: takeProfitController,
                allowNegative: false,
              ),
              EditTextFormFieldNumberKeyboardWidget(
                hintText: 'Stop Loss',
                icon: Icons.warning_amber_rounded,
                size: size,
                validator: (value) {
                  if (value.isEmpty) {
                    buildSnackError(
                      'Invalid Stop Loss',
                      context,
                      size,
                    );
                    return '';
                  }
                  else if (entryPriceController.text != null){
                    if(actionSelectedValue == 'Buy'){
                      if(double.parse(value) > double.parse(entryPriceController.text)){
                        buildSnackError(
                          'Stop Loss higher than Entry Price',
                          context,
                          size,
                        );
                        return '';
                      }
                    }
                    else if(actionSelectedValue == 'Sell'){
                      if(double.parse(value) < double.parse(entryPriceController.text)){
                        buildSnackError(
                          'Stop Loss lower than Entry Price',
                          context,
                          size,
                        );
                        return '';
                      }
                    }
                  }
                  return null;
                },
                formKey: _stopLossKey,
                controller: stopLossController,
                allowNegative: false,
              ),
              EditTextFormFieldNumberKeyboardWidget(
                hintText: 'Profit and Loss',
                icon: Icons.money_rounded,
                size: size,
                validator: (value) {
                  if (value.isEmpty) {
                    buildSnackError(
                      'Invalid P&L',
                      context,
                      size,
                    );
                    return '';
                  }
                  return null;
                },
                formKey: _profitAndLossKey,
                controller: profitAndLossController,
                allowNegative: true,
              ),
              EditTextFormFieldNumberKeyboardWidget(
                hintText: 'Risk and Reward',
                icon: Icons.compare_arrows_rounded,
                size: size,
                validator: (value) {
                  if (value.isEmpty) {
                    buildSnackError(
                      'Invalid RRR',
                      context,
                      size,
                    );
                    return '';
                  }
                  return null;
                },
                formKey: _riskRewardRatioKey,
                controller: riskRewardRatioController,
                allowNegative: true,
              ),
              EditTextFormFieldWidget(
                hintText: 'Feedback',
                icon: Icons.feedback_rounded,
                password: false,
                size: size,
                validator: (value) {
                  if (value.length <= 0) {
                    buildSnackError(
                      'Invalid Feedback',
                      context,
                      size,
                    );
                    return '';
                  }
                  return null;
                },
                formKey: _feedbackKey,
                controller: feedbackController,
              ),
              EditTextFormFieldNumberKeyboardWidget(
                hintText: 'Fees',
                icon: Icons.payments_rounded,
                size: size,
                validator: (value) {
                  if (value.isEmpty) {
                    buildSnackError(
                      'Invalid Fees',
                      context,
                      size,
                    );
                    return '';
                  }
                  return null;
                },
                formKey: _feesKey,
                controller: feesController,
                allowNegative: false,
              ),
              DateTimePickerWidget(
                size: size,
                hintText: 'Entry Date',
                validator: (value) {
                  if (value.isEmpty) {
                    buildSnackError(
                      'Invalid Entry Date',
                      context,
                      size,
                    );
                    return '';
                  }
                  return null;
                },
                formKey: _entryDateKey,
                icon: Icons.edit_calendar_rounded,
                controller: entryDateController,
              ),
              DateTimePickerWidget(
                size: size,
                hintText: 'Exit Date',
                validator: (value) {
                  if (value.isEmpty) {
                    buildSnackError(
                      'Invalid Exit Date',
                      context,
                      size,
                    );
                    return '';
                  }
                  else if(entryDateController.text != null){
                    DateTime entryDateTime = DateTime.parse(entryDateController.text);
                    Timestamp entryTimestamp = Timestamp.fromDate(entryDateTime);

                    DateTime exitDateTime = DateTime.parse(exitDateController.text);
                    Timestamp exitTimestamp = Timestamp.fromDate(exitDateTime);

                    if (exitTimestamp.compareTo(entryTimestamp) < 0) {
                      buildSnackError(
                        'Exit Date earlier than Entry Date',
                        context,
                        size,
                      );
                      return '';
                    }
                    else{
                      return null;
                    }
                  }
                  return null;
                },
                formKey: _exitDateKey,
                icon: Icons.access_time_filled_rounded,
                controller: exitDateController,
              ),
              _pickedFile != null
                  ? Padding(
                padding: const EdgeInsets.all(20),
                child: Image.file(
                  File(_pickedFile!.path!),
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                ),
              )
                  : const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Image Will Be Displayed Here',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  selectFile();
                },
                child: Container(
                  width: size.width * 0.9,
                  height: size.height * 0.05,
                  decoration: const BoxDecoration(
                    color: Color(0xff151f2c),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: const Center(
                    child: Text(
                      "UPLOAD IMAGE",
                      style: TextStyle(
                        color: Color(0xffADA4A5),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedPadding(
                duration: const Duration(milliseconds: 500),
                padding: EdgeInsets.only(top: size.height * 0.025),
                child: ButtonWidget(
                  text: "Submit",
                  backColor: const [
                    Colors.blueAccent,
                    Colors.lightBlueAccent,
                  ],
                  textColor: const [
                    Colors.black,
                    Colors.black,
                  ],
                  onPressed: () async {
                    if(_actionKey.currentState!.validate()){
                      if(_symbolKey.currentState!.validate()){
                        if(_timeFrameKey.currentState!.validate()){
                          if(_strategyKey.currentState!.validate()){
                            if(_entryPriceKey.currentState!.validate()){
                              if(_exitPriceKey.currentState!.validate()){
                                if(_takeProfitKey.currentState!.validate()){
                                  if(_stopLossKey.currentState!.validate()){
                                    if(_profitAndLossKey.currentState!.validate()){
                                      if(_riskRewardRatioKey.currentState!.validate()){
                                        if(_feedbackKey.currentState!.validate()){
                                          if(_feesKey.currentState!.validate()){
                                            if(_entryDateKey.currentState!.validate()){
                                              if(_exitDateKey.currentState!.validate()){
                                                uploadToFirebase();
                                              }
                                            }
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              buildProgress(),
            ],
          ),
        ),
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildSnackError(
      String error, context, size) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black,
        content: SizedBox(
          height: size.height * 0.02,
          child: Center(
            child: Text(error),
          ),
        ),
      ),
    );
  }
}
