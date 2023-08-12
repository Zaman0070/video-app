// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class VideoModel {
  String? uid;
  String? privacy;
  String? videoUrl;
  String? thumbnailUrl;
  String? category;
  String? title;
  String? description;
  List<dynamic>? bookmarks;
  int? time;
  String? paid;
  VideoModel({
    this.uid,
    this.privacy,
    this.videoUrl,
    this.thumbnailUrl,
    this.category,
    this.title,
    this.description,
    this.bookmarks,
    this.time,
    this.paid,
  });

  VideoModel copyWith({
    String? uid,
    String? privacy,
    String? videoUrl,
    String? thumbnailUrl,
    String? category,
    String? title,
    String? description,
    List<dynamic>? bookmarks,
    int? time,
    String? paid,
  }) {
    return VideoModel(
      uid: uid ?? this.uid,
      privacy: privacy ?? this.privacy,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      bookmarks: bookmarks ?? this.bookmarks,
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
      'title': title,
      'description': description,
      'bookmarks': bookmarks,
      'time': time,
      'paid': paid,
    };
  }

  factory VideoModel.fromMap(Map<String, dynamic> map) {
    return VideoModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      privacy: map['privacy'] != null ? map['privacy'] as String : null,
      videoUrl: map['videoUrl'] != null ? map['videoUrl'] as String : null,
      thumbnailUrl: map['thumbnailUrl'] != null ? map['thumbnailUrl'] as String : null,
      category: map['category'] != null ? map['category'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      bookmarks: map['bookmarks'] != null ? List<dynamic>.from((map['bookmarks'] as List<dynamic>)) : null,
      time: map['time'] != null ? map['time'] as int : null,
      paid: map['paid'] != null ? map['paid'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VideoModel.fromJson(String source) => VideoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VideoModel(uid: $uid, privacy: $privacy, videoUrl: $videoUrl, thumbnailUrl: $thumbnailUrl, category: $category, title: $title, description: $description, bookmarks: $bookmarks, time: $time, paid: $paid)';
  }

  @override
  bool operator ==(covariant VideoModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.uid == uid &&
      other.privacy == privacy &&
      other.videoUrl == videoUrl &&
      other.thumbnailUrl == thumbnailUrl &&
      other.category == category &&
      other.title == title &&
      other.description == description &&
      listEquals(other.bookmarks, bookmarks) &&
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
      title.hashCode ^
      description.hashCode ^
      bookmarks.hashCode ^
      time.hashCode ^
      paid.hashCode;
  }
}
