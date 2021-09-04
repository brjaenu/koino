import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Prayer extends Equatable {
  final String id;
  final String title;
  final String description;
  final String groupId;
  final String authorId;
  final int prayedAmount;
  final bool isAnonymous;

  const Prayer({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.prayedAmount,
    @required this.isAnonymous,
    @required this.groupId,
    @required this.authorId,
  });

  static final empty = Prayer(
    id: '',
    title: '',
    description: '',
    prayedAmount: 0,
    isAnonymous: false,
    authorId: '',
    groupId: '',
  );

  Map<String, dynamic> toDocument() {
    return {
      'title': this.title,
      'description': this.description,
      'isAnonymous': this.isAnonymous,
      'prayedAmount': this.prayedAmount,
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
      prayedAmount: data['prayedAmount'] ?? 0,
      authorId: data['authorId'] ?? '',
      groupId: data['groupId'] ?? '',
    );
  }

  @override
  List<Object> get props =>
      [id, title, description, isAnonymous, prayedAmount, authorId, groupId];

  Prayer copyWith({
    String id,
    String title,
    String description,
    String groupId,
    String authorId,
    int prayerAmount,
    bool isAnonymous,
  }) {
    return Prayer(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      groupId: groupId ?? this.groupId,
      authorId: authorId ?? this.authorId,
      prayedAmount: prayedAmount ?? this.prayedAmount,
      isAnonymous: isAnonymous ?? this.isAnonymous,
    );
  }
}
