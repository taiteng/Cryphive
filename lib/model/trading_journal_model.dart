import 'package:cloud_firestore/cloud_firestore.dart';

class TradingJournalModel {
  String action;
  Timestamp entryDate;
  Timestamp exitDate;
  num entryPrice;
  num exitPrice;
  String feedback;
  num fees;
  String image;
  String journalID;
  num profitAndLoss;
  num riskOfReward;
  num stopLoss;
  num takeProfit;
  String strategy;
  String symbol;
  String timeframe;

  TradingJournalModel({
    required this.action,
    required this.entryDate,
    required this.exitDate,
    required this.entryPrice,
    required this.exitPrice,
    required this.feedback,
    required this.fees,
    required this.image,
    required this.journalID,
    required this.profitAndLoss,
    required this.riskOfReward,
    required this.stopLoss,
    required this.takeProfit,
    required this.strategy,
    required this.symbol,
    required this.timeframe,
  });
}