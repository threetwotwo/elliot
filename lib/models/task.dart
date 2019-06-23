import 'package:elliot/tags/tag.dart';
import 'package:flutter/foundation.dart';

class Task {
  Tag tag;
  final int id;
  final String title;
  final String description;
  final String details;
  DateTime deadline;
  int progress;

  Task({
    @required this.id,
    this.tag,
    @required this.title,
    this.description,
    this.details,
    this.deadline,
    this.progress,
  });

  Task copyWith({
    int id,
    Tag tag,
    String title,
    String description,
    String details,
    DateTime dueDate,
    int progress,
  }) {
    return Task(
      id: id ?? this.id,
      tag: tag,
      title: title ?? this.title,
      description: description ?? this.description,
      details: details ?? this.details,
      deadline: dueDate ?? this.deadline,
      progress: progress ?? this.progress,
    );
  }

  factory Task.initial() {
    return Task(
      id: DateTime.now().millisecondsSinceEpoch,
      title: '',
      description: '',
      details: '',
      progress: 0,
      deadline: DateTime.now(),
    );
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] ?? '',
      tag: map['tag'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      details: map['details'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'tag': tag.title,
      'title': title,
      'description': description,
      'details': details,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
