import 'package:cryphive/model/trading_journal_model.dart';
import 'package:flutter/material.dart';

class EditJournalPage extends StatefulWidget {

  final TradingJournalModel tradingJournal;

  const EditJournalPage({
    super.key,
    required this.tradingJournal,
  });

  @override
  State<EditJournalPage> createState() => _EditJournalPageState();
}

class _EditJournalPageState extends State<EditJournalPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
