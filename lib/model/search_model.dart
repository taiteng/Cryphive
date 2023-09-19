import 'dart:convert';

List<SearchModel> searchModelFromJson(String str) {
  final jsonData = json.decode(str)['coins'] as List<dynamic>;
  return jsonData
      .map((dynamic item) => SearchModel.fromJson(item))
      .toList();
}

String searchModelToJson(List<SearchModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchModel {
  SearchModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.thumb,
    required this.large,
    required this.marketCapRank,
  });

  String id;
  String symbol;
  String name;
  String thumb;
  String large;
  int marketCapRank;

  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
    id: json['id'],
    symbol: json['symbol'],
    name: json['name'],
    thumb: json['thumb'],
    large: json['large'],
    marketCapRank: json['market_cap_rank'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "symbol": symbol,
    "name": name,
    "thumb": thumb,
    "large": large,
    "market_cap_rank": marketCapRank,
  };
}