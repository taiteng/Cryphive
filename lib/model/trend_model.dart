import 'dart:convert';

List<TrendModel> trendModelFromJson(String str) {
  final Map<String, dynamic> data = json.decode(str);
  final List<dynamic> coinList = data['coins'];
  return coinList.map((json) => TrendModel.fromJson(json)).toList();
}

String trendModelToJson(List<TrendModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TrendModel {
  TrendModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.thumb,
    required this.large,
    required this.marketCapRank,
    required this.priceInBTC,
  });

  String id;
  String symbol;
  String name;
  String thumb;
  String large;
  int marketCapRank;
  double priceInBTC;

  factory TrendModel.fromJson(Map<String, dynamic> json) => TrendModel(
    id: json['item']['id'],
    symbol: json['item']['symbol'],
    name: json['item']['name'],
    thumb: json['item']['thumb'],
    large: json['item']['large'],
    marketCapRank: json['item']['market_cap_rank'],
    priceInBTC: json['item']['price_btc'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "symbol": symbol,
    "name": name,
    "thumb": thumb,
    "large": large,
    "market_cap_rank": marketCapRank,
    "price_btc": priceInBTC,
  };
}