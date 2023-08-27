// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class VideoModel {
  String? uid;
  String? privacy;
  String? videoUrl;
  String? thumbnailUrl;
  String? category;
  String? categoryKh;
  String? title;
  String? description;
  List<dynamic>? bookmarks;
  List<dynamic>? watchList;
  int? time;
  String? paid;
  VideoModel({
    this.uid,
    this.privacy,
    this.videoUrl,
    this.thumbnailUrl,
    this.category,
    this.categoryKh,
    this.title,
    this.description,
    this.bookmarks,
    this.watchList,
    this.time,
    this.paid,
  });

  VideoModel copyWith({
    String? uid,
    String? privacy,
    String? videoUrl,
    String? thumbnailUrl,
    String? category,
    String? categoryKh,
    String? title,
    String? description,
    List<dynamic>? bookmarks,
    List<dynamic>? watchList,
    int? time,
    String? paid,
  }) {
    return VideoModel(
      uid: uid ?? this.uid,
      privacy: privacy ?? this.privacy,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      category: category ?? this.category,
      categoryKh: categoryKh ?? this.categoryKh,
      title: title ?? this.title,
      description: description ?? this.description,
      bookmarks: bookmarks ?? this.bookmarks,
      watchList: watchList ?? this.watchList,
      time: time ?? this.time,
      paid: paid ?? this.paid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'privacy': privacy,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'category': category,
      'categoryKh': categoryKh,
      'title': title,
      'description': description,
      'bookmarks': bookmarks,
      'watchList': watchList,
      'time': time,
      'paid': paid,
    };
  }

  factory VideoModel.fromMap(Map<String, dynamic> map) {
    return VideoModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      privacy: map['privacy'] != null ? map['privacy'] as String : null,
      videoUrl: map['videoUrl'] != null ? map['videoUrl'] as String : null,
      thumbnailUrl:
          map['thumbnailUrl'] != null ? map['thumbnailUrl'] as String : null,
      category: map['category'] != null ? map['category'] as String : null,
      categoryKh:
          map['categoryKh'] != null ? map['categoryKh'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      bookmarks: map['bookmarks'] != null
          ? List<dynamic>.from((map['bookmarks'] as List<dynamic>))
          : null,
      watchList: map['watchList'] != null
          ? List<dynamic>.from((map['watchList'] as List<dynamic>))
          : null,
      time: map['time'] != null ? map['time'] as int : null,
      paid: map['paid'] != null ? map['paid'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VideoModel.fromJson(String source) =>
      VideoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VideoModel(uid: $uid, privacy: $privacy, videoUrl: $videoUrl, thumbnailUrl: $thumbnailUrl, category: $category, categoryKh: $categoryKh, title: $title, description: $description, bookmarks: $bookmarks, watchList: $watchList, time: $time, paid: $paid)';
  }

  @override
  bool operator ==(covariant VideoModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.privacy == privacy &&
        other.videoUrl == videoUrl &&
        other.thumbnailUrl == thumbnailUrl &&
        other.category == category &&
        other.categoryKh == categoryKh &&
        other.title == title &&
        other.description == description &&
        listEquals(other.bookmarks, bookmarks) &&
        listEquals(other.watchList, watchList) &&
        other.time == time &&
        other.paid == paid;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        privacy.hashCode ^
        videoUrl.hashCode ^
        thumbnailUrl.hashCode ^
        category.hashCode ^
        categoryKh.hashCode ^
        title.hashCode ^
        description.hashCode ^
        bookmarks.hashCode ^
        watchList.hashCode ^
        time.hashCode ^
        paid.hashCode;
  }
}
