import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Prayer extends Equatable {
  final String id;
  final String title;
  final String description;
  final String groupId;
  final String authorId;
  final String username;
  final int prayerAmount;
  final bool isAnonymous;

  const Prayer({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.prayerAmount,
    @required this.isAnonymous,
    @required this.username,
    @required this.groupId,
    @required this.authorId,
  });

  static final empty = Prayer(
    id: '',
    title: '',
    description: '',
    prayerAmount: 0,
    isAnonymous: false,
    username: '',
    authorId: '',
    groupId: '',
  );

  Map<String, dynamic> toDocument() {
    return {
      'title': this.title,
      'description': this.description,
      'isAnonymous': this.isAnonymous,
      'prayerAmount': this.prayerAmount,
      'username': this.username,
      'authorId': this.authorId,
      'groupId': groupId,
    };
  }

  static Prayer fromDocument(DocumentSnapshot doc) {
    if (doc == null) return null;
    final data = doc.data() as Map;

    return Prayer(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      isAnonymous: data['isAnonymous'] ?? false,
      prayerAmount: data['prayerAmount'] ?? 0,
      username: data['username'] ?? '',
      authorId: data['authorId'] ?? '',
      groupId: data['groupId'] ?? '',
    );
  }

  @override
  List<Object> get props =>
      [id, title, description, isAnonymous, prayerAmount, authorId, groupId];

  Prayer copyWith({
    String id,
    String title,
    String description,
    String groupId,
    String authorId,
    String username,
    int prayerAmount,
    bool isAnonymous,
  }) {
    return Prayer(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        groupId: groupId ?? this.groupId,
        authorId: authorId ?? this.authorId,
        prayerAmount: prayerAmount ?? this.prayerAmount,
        isAnonymous: isAnonymous ?? this.isAnonymous,
        username: username);
  }
}
