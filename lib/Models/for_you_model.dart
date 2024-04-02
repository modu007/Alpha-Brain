// To parse this JSON data, do
//
//     final forYouModel = forYouModelFromJson(jsonString);

import 'dart:convert';

ForYouModel forYouModelFromJson(String str) =>
    ForYouModel.fromJson(json.decode(str));

String forYouModelToJson(ForYouModel data) => json.encode(data.toJson());

class ForYouModel {
  final String id;
  final String dateTime;
  final String? imageUrl;
  final List? myBookmark;
  final List? myEmojis;
  final String newsUrl;
  final String source;
  final Summary summary;
  final List<String> tags;
  final bool yt;
  final int? love;

  ForYouModel({
    required this.id,
    required this.dateTime,
    required this.imageUrl,
    required this.myBookmark,
    required this.myEmojis,
    required this.newsUrl,
    required this.source,
    required this.summary,
    required this.tags,
    required this.yt,
    required this.love
  });

  factory ForYouModel.fromJson(Map<String, dynamic> json) => ForYouModel(
    id: json["_id"],
    dateTime: json["date_time"],
    imageUrl: json["image_url"],
    myBookmark: List<dynamic>.from(json["my_bookmark"].map((x) => x)),
    myEmojis: List<dynamic>.from(json["my_emojis"].map((x) => x)),
    newsUrl: json["news_url"],
    source: json["source"],
    summary: Summary.fromJson(json["summary"]),
    tags: List<String>.from(json["tags"].map((x) => x)),
    yt: json["yt"],
    love: json["love"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "date_time": dateTime,
    "image_url": imageUrl,
    "my_bookmark": List.from(myBookmark!.map((x) => x)),
    "my_emojis": List.from(myEmojis!.map((x) => x)),
    "news_url": newsUrl,
    "source": source,
    "summary": summary.toJson(),
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "yt": yt,
    "love": love,
  };
}

class Summary {
  final List<KeyPoint> keyPoints;
  final String title;

  Summary({
    required this.keyPoints,
    required this.title,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    keyPoints: List<KeyPoint>.from(json["key_points"].map((x) => KeyPoint.fromJson(x))),
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "key_points": List<dynamic>.from(keyPoints.map((x) => x.toJson())),
    "title": title,
  };
}

class KeyPoint {
  final String description;
  final String subHeading;

  KeyPoint({
    required this.description,
    required this.subHeading,
  });

  factory KeyPoint.fromJson(Map<String, dynamic> json) => KeyPoint(
    description: json["description"],
    subHeading: json["sub_heading"],
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "sub_heading": subHeading,
  };
}
