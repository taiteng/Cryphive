import 'dart:io';

import 'package:cryphive/model/search_model.dart';
import 'package:cryphive/widgets/date_time_picker_widget.dart';
import 'package:cryphive/widgets/drop_down_widget.dart';
import 'package:cryphive/widgets/edit_text_form_field_number_keyboard_widget.dart';
import 'package:cryphive/widgets/edit_text_form_field_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AddJournalPage extends StatefulWidget {
  const AddJournalPage({super.key});

  @override
  State<AddJournalPage> createState() => _AddJournalPageState();
}

class _AddJournalPageState extends State<AddJournalPage> {

  final User? user = FirebaseAuth.instance.currentUser;

  final _symbolKey = GlobalKey<FormState>();
  final _actionKey = GlobalKey<FormState>();
  final _timeFrameKey = GlobalKey<FormState>();
  final _strategyKey = GlobalKey<FormState>();
  final _entryPriceKey = GlobalKey<FormState>();
  final _exitPriceKey = GlobalKey<FormState>();
  final _takeProfitKey = GlobalKey<FormState>();
  final _stopLossKey = GlobalKey<FormState>();
  final _profitAndLossKey = GlobalKey<FormState>();
  final _riskAndRewardKey = GlobalKey<FormState>();
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
  TextEditingController riskAndRewardController = TextEditingController();
  TextEditingController feedbackController = TextEditingController();
  TextEditingController feesController = TextEditingController();
  TextEditingController entryDateController = TextEditingController();
  TextEditingController exitDateController = TextEditingController();

  PlatformFile? _pickedFile;
  UploadTask? _uploadTask;
  String? urlDownload;

  Future selectFile() async{
    final result = await FilePicker.platform.pickFiles();
    if(result == null) return;

    setState(() {
      _pickedFile = result.files.first;
    });
  }

  Future uploadFile() async{
    final path = 'UserProfile/${_pickedFile!.name}';
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
  }

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
    riskAndRewardController.dispose();
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
              const SizedBox(
                height: 10,
              ),
              DropDownWidget(
                selectedValue: 'Buy',
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
              ),
              const SizedBox(
                height: 10,
              ),
              DropDownWidget(
                selectedValue: '1H',
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
              ),
              const SizedBox(
                height: 10,
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
              const SizedBox(
                height: 10,
              ),
              EditTextFormFieldNumberKeyboardWidget(
                hintText: 'Entry Price',
                icon: Icons.trending_up_outlined,
                password: false,
                size: size,
                validator: (value) {
                  if (value <= 0) {
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
              const SizedBox(
                height: 10,
              ),
              EditTextFormFieldNumberKeyboardWidget(
                hintText: 'Exit Price',
                icon: Icons.trending_down_rounded,
                password: false,
                size: size,
                validator: (value) {
                  if (value <= 0) {
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
              const SizedBox(
                height: 10,
              ),
              EditTextFormFieldNumberKeyboardWidget(
                hintText: 'Take Profit',
                icon: Icons.trending_flat_rounded,
                password: false,
                size: size,
                validator: (value) {
                  if (value <= 0) {
                    buildSnackError(
                      'Invalid Take Profit',
                      context,
                      size,
                    );
                    return '';
                  }
                  return null;
                },
                formKey: _takeProfitKey,
                controller: takeProfitController,
                allowNegative: false,
              ),
              const SizedBox(
                height: 10,
              ),
              EditTextFormFieldNumberKeyboardWidget(
                hintText: 'Stop Loss',
                icon: Icons.warning_amber_rounded,
                password: false,
                size: size,
                validator: (value) {
                  if (value <= 0) {
                    buildSnackError(
                      'Invalid Stop Loss',
                      context,
                      size,
                    );
                    return '';
                  }
                  return null;
                },
                formKey: _stopLossKey,
                controller: stopLossController,
                allowNegative: false,
              ),
              const SizedBox(
                height: 10,
              ),
              EditTextFormFieldNumberKeyboardWidget(
                hintText: 'Profit and Loss',
                icon: Icons.money_rounded,
                password: false,
                size: size,
                validator: (value) {
                  if (value == null) {
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
              const SizedBox(
                height: 10,
              ),
              EditTextFormFieldNumberKeyboardWidget(
                hintText: 'Risk and Reward',
                icon: Icons.compare_arrows_rounded,
                password: false,
                size: size,
                validator: (value) {
                  if (value == null) {
                    buildSnackError(
                      'Invalid RRR',
                      context,
                      size,
                    );
                    return '';
                  }
                  return null;
                },
                formKey: _riskAndRewardKey,
                controller: riskAndRewardController,
                allowNegative: true,
              ),
              const SizedBox(
                height: 10,
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
              const SizedBox(
                height: 10,
              ),
              EditTextFormFieldNumberKeyboardWidget(
                hintText: 'Fees',
                icon: Icons.payments_rounded,
                password: false,
                size: size,
                validator: (value) {
                  if (value < 0) {
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
              const SizedBox(
                height: 10,
              ),
              DateTimePickerWidget(
                size: size,
                hintText: 'Entry Date',
                validator: (value) {  },
                formKey: _entryDateKey,
                icon: Icons.edit_calendar_rounded,
                controller: entryDateController,
              ),
              const SizedBox(
                height: 10,
              ),
              DateTimePickerWidget(
                size: size,
                hintText: 'Exit Date',
                validator: (value) {  },
                formKey: _exitDateKey,
                icon: Icons.access_time_filled_rounded,
                controller: exitDateController,
              ),
              const SizedBox(
                height: 10,
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
                  : Padding(
                padding: const EdgeInsets.all(20),
                child: Image.network(
                  'https://www.entrepreneurshipinabox.com/wp-content/uploads/A-Basic-Guide-To-Stock-Trading-1024x682.jpg',
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: 200,
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
