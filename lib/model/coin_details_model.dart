class CoinDetailsModel {
  CoinDetailsModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.links,
    required this.image,
    required this.description,
    required this.marketCapRank,
    required this.marketData,
  });

  String id;
  String symbol;
  String name;
  Links links;
  ImageUrls image;
  Description description;
  int marketCapRank;
  MarketData marketData;

  factory CoinDetailsModel.fromJson(Map<String, dynamic> json) => CoinDetailsModel(
    id: json["id"],
    symbol: json["symbol"],
    name: json["name"],
    links: Links.fromJson(json['links']),
    image: ImageUrls.fromJson(json['image']),
    description: Description.fromJson(json['description']),
    marketCapRank: json["market_cap_rank"],
    marketData: MarketData.fromJson(json['market_data']),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "symbol": symbol,
    "name": name,
    "links": links.toJson(),
    "image": image.toJson(),
    "description": description.toJson(),
    "market_data": marketData.toJson(),
  };
}

class Description {
  String en;

  Description({
    required this.en,
  });

  factory Description.fromJson(Map<String, dynamic> json) {
    return Description(
      en: json['en'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "en": en,
    };
  }
}

class Links {
  List<String> homepage;
  List<String> blockchainSite;
  List<String> officialForumUrl;

  Links({
    required this.homepage,
    required this.blockchainSite,
    required this.officialForumUrl,
  });

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      homepage: List<String>.from(json['homepage']),
      blockchainSite: List<String>.from(json['blockchain_site']),
      officialForumUrl: List<String>.from(json['official_forum_url']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "homepage": homepage,
      "blockchain_site": blockchainSite,
      "official_forum_url": officialForumUrl,
    };
  }
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

  MarketData({
    required this.totalVolume,
    required this.currentPrice,
    required this.marketCapChangePercentage24H,
    required this.low24h,
    required this.high24h,
  });

  factory MarketData.fromJson(Map<String, dynamic> json) {
    return MarketData(
      totalVolume: (json['total_volume'] ?? {})['usd']?.toDouble() ?? 0.0,
      currentPrice: (json['current_price'] ?? {})['usd']?.toDouble() ?? 0.0,
      marketCapChangePercentage24H: (json['market_cap_change_percentage_24h'])?.toDouble() ?? 0.0,
      low24h: (json['low_24h'] ?? {})['usd']?.toDouble() ?? 0.0,
      high24h: (json['high_24h'] ?? {})['usd']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "totalVolume": totalVolume,
      "currentPrice": currentPrice,
      "marketCapChangePercentage24H": marketCapChangePercentage24H,
      "low24h": low24h,
      "high24h": high24h,
    };
  }
}