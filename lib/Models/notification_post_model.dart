import 'dart:convert';

NotificationPostModel notificationPostModelFromJson(String str) =>
    NotificationPostModel.fromJson(json.decode(str));

String notificationPostModelToJson(NotificationPostModel data) =>
    json.encode(data.toJson());

class NotificationPostModel {
  final String id;
  final String dateTime;
  final String? imageUrl;
  final List? myBookmark;
  final List? myEmojis;
  final String newsUrl;
  final String source;
  final Summary summary;
  final Summary? summaryHi; // Updated to be nullable
  final List<String> tags;
  final bool yt;
  final int? love;
  final String? shortUrl;


  NotificationPostModel({
    required this.id,
    required this.dateTime,
    required this.imageUrl,
    required this.myBookmark,
    required this.myEmojis,
    required this.newsUrl,
    required this.source,
    required this.summary,
    required this.summaryHi,
    required this.tags,
    required this.yt,
    required this.love,
    required this.shortUrl,
  });

  factory NotificationPostModel.fromJson(Map<String, dynamic> json) => NotificationPostModel(
    id: json["_id"],
    dateTime: json["date_time"],
    imageUrl: json["image_url"],
    myBookmark: List<dynamic>.from(json["my_bookmark"].map((x) => x)),
    myEmojis: List<dynamic>.from(json["my_emojis"].map((x) => x)),
    newsUrl: json["news_url"],
    source: json["source"],
    summary: Summary.fromJson(json["summary"]),
    summaryHi: json["summary_hi"] != null
        ? Summary.fromJson(json["summary_hi"])
        : null,
    tags: List<String>.from(json["tags"].map((x) => x)),
    yt: json["yt"],
    love: json["love"],
    shortUrl: json["short_url"]
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
    "summary_hi": summaryHi?.toJson(), // Include summary_hi only if it's not null
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "yt": yt,
    "love": love,
    "short_url":shortUrl
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
    keyPoints: List<KeyPoint>.from(
        json["key_points"].map((x) => KeyPoint.fromJson(x))),
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
