import 'dart:convert';

BookmarkPostModel bookmarkPostModelFromJson(String str) => BookmarkPostModel.fromJson(json.decode(str));
String bookmarkPostModelToJson(BookmarkPostModel data) => json.encode(data.toJson());

class BookmarkPostModel {
  final String? emoji;
  final List<LikedPost> likedPost;
  final String postDateTime;
  final String postId;

  BookmarkPostModel({
    required this.likedPost,
    required this.postDateTime,
    required this.postId,
    required this.emoji
  });

  factory BookmarkPostModel.fromJson(Map<String, dynamic> json) => BookmarkPostModel(
    likedPost: List<LikedPost>.from(json["liked_post"].map((x) => LikedPost.fromJson(x))),
    postDateTime: json["post_date_time"],
    postId: json["post_id"],
    emoji: json["emoji"]
  );

  Map<String, dynamic> toJson() => {
    "liked_post": List<dynamic>.from(likedPost.map((x) => x.toJson())),
    "post_date_time": postDateTime,
    "post_id": postId,
    "emoji":emoji
  };
}

class LikedPost {
  final String id;
  final int? bookmarkCount;
  final String dateTime;
  final String? imageUrl;
  final int? love;
  final String newsUrl;
  final String source;
  final Summary summary;
  final Summary? summaryHi; // Updated to be nullable
  final List<String> tags;

  LikedPost({
    required this.id,
    required this.bookmarkCount,
    required this.dateTime,
    required this.imageUrl,
    required this.love,
    required this.newsUrl,
    required this.source,
    required this.summary,
    required this.tags,
    required this.summaryHi,
  });

  factory LikedPost.fromJson(Map<String, dynamic> json) => LikedPost(
    id: json["_id"],
    bookmarkCount: json["bookmark_count"],
    dateTime: json["date_time"],
    imageUrl: json["image_url"],
    love: json["love"],
    newsUrl: json["news_url"],
    source: json["source"],
    summary: Summary.fromJson(json["summary"]),
    tags: List<String>.from(json["tags"].map((x) => x)),
    summaryHi: json["summary_hi"] != null
        ? Summary.fromJson(json["summary_hi"])
        : null,
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "bookmark_count": bookmarkCount,
    "date_time": dateTime,
    "image_url": imageUrl,
    "love": love,
    "news_url": newsUrl,
    "source": source,
    "summary": summary.toJson(),
    "summary_hi": summaryHi?.toJson(),
    "tags": List<dynamic>.from(tags.map((x) => x)),
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
