class WatchlistModel {
  WatchlistModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.marketCapRank,
    required this.marketData,
  });

  String id;
  String symbol;
  String name;
  ImageUrls image;
  int marketCapRank;
  MarketData marketData;

  factory WatchlistModel.fromJson(Map<String, dynamic> json) => WatchlistModel(
    id: json["id"],
    symbol: json["symbol"],
    name: json["name"],
    image: ImageUrls.fromJson(json['image']),
    marketCapRank: json["market_cap_rank"],
    marketData: MarketData.fromJson(json['market_data']),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "symbol": symbol,
    "name": name,
    "image": image.toJson(),
    "market_cap_rank": marketCapRank,
    "market_data": marketData.toJson(),
  };
}

class SparklineIn7D {
  SparklineIn7D({
    required this.price,
  });

  List<double> price;

  factory SparklineIn7D.fromJson(Map<String, dynamic> json) => SparklineIn7D(
    price: List<double>.from(json["price"].map((x) => x?.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "price": List<dynamic>.from(price.map((x) => x)),
  };
}

class ImageUrls {
  String thumb;
  String small;
  String large;

  ImageUrls({
    required this.thumb,
    required this.small,
    required this.large,
  });

  factory ImageUrls.fromJson(Map<String, dynamic> json) {
    return ImageUrls(
      thumb: json['thumb'],
      small: json['small'],
      large: json['large'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "thumb": thumb,
      "small": small,
      "large": large,
    };
  }
}

class MarketData {
  double totalVolume;
  double currentPrice;
  double marketCapChangePercentage24H;
  double low24h;
  double high24h;
  double priceChange24H;
  List<double> sparklineIn7D;

  MarketData({
    required this.totalVolume,
    required this.currentPrice,
    required this.marketCapChangePercentage24H,
    required this.low24h,
    required this.high24h,
    required this.priceChange24H,
    required this.sparklineIn7D,
  });

  factory MarketData.fromJson(Map<String, dynamic> json) {
    return MarketData(
      totalVolume: (json['total_volume'] ?? {})['usd']?.toDouble() ?? 0.0,
      currentPrice: (json['current_price'] ?? {})['usd']?.toDouble() ?? 0.0,
      marketCapChangePercentage24H: (json['market_cap_change_percentage_24h'])?.toDouble() ?? 0.0,
      low24h: (json['low_24h'] ?? {})['usd']?.toDouble() ?? 0.0,
      high24h: (json['high_24h'] ?? {})['usd']?.toDouble() ?? 0.0,
      priceChange24H: (json['price_change_24h'])?.toDouble() ?? 0.0,
      sparklineIn7D: List<double>.from((json['sparkline_7d'] ?? {})["price"].map((x) => x?.toDouble())),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "totalVolume": totalVolume,
      "currentPrice": currentPrice,
      "marketCapChangePercentage24H": marketCapChangePercentage24H,
      "low24h": low24h,
      "high24h": high24h,
      "priceChange24H": priceChange24H,
      "sparklineIn7D": List<dynamic>.from(sparklineIn7D.map((x) => x)),
    };
  }
}