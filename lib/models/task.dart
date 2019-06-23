import 'package:elliot/tags/tag.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:uuid/uuid.dart';

class Task {
  final Tag tag;
  final String id;
  final String title;
  final String description;
  final String details;
  DateTime deadline;
  int progress;

  final DateTime dateCreated;

  Task({
    @required this.id,
    this.tag,
    @required this.title,
    this.description,
    this.details,
    this.deadline,
    this.progress,
    this.dateCreated,
  });

  Task copyWith({
    Tag tag,
    String title,
    String description,
    String details,
    DateTime dateCreated,
    DateTime deadline,
    int progress,
  }) {
    return Task(
      id: this.id,
      tag: tag,
      title: title ?? this.title,
      description: description ?? this.description,
      details: details ?? this.details,
      deadline: deadline ?? this.deadline,
      dateCreated: dateCreated ?? this.deadline,
      progress: progress ?? this.progress,
    );
  }

  factory Task.initial() {
    return Task(
      id: Uuid().v4(),
      dateCreated: DateTime.now(),
      title: '',
      tag: null,
      description: '',
      details: '',
      progress: 0,
      deadline: null,
    );
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    final task = Task(
      id: map['id'] ?? '',
      tag: map['tagTitle'] == null
          ? null
          : Tag(title: map['tagTitle'], color: Color(map['tagColor'])),
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      details: map['details'] ?? '',
      dateCreated:
          DateTime.fromMillisecondsSinceEpoch((map['dateCreated'] as int)),
      deadline: map['deadline'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch((map['deadline'] as int)),
      progress: map['progress'] ?? 0,
    );
    return task;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'tagTitle': tag == null ? null : tag.title,
      'tagColor': tag == null ? null : tag.color.value,
      'title': title,
      'description': description,
      'details': details,
      //SQL only supports int type
      'dateCreated':
          dateCreated == null ? null : dateCreated.millisecondsSinceEpoch,
      'deadline': deadline == null ? null : deadline.millisecondsSinceEpoch,
      'progress': progress
    };

    return map;
  }
}
