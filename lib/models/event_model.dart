import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Event extends Equatable {
  final String id;
  final String title;
  final String description;
  final String groupId;
  final String authorId;
  final List<String> registeredUsers;
  final int registrationAmount;
  final String speaker;
  final Timestamp date;

  const Event({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.speaker,
    @required this.registeredUsers,
    @required this.registrationAmount,
    @required this.date,
    @required this.groupId,
    @required this.authorId,
  });

  static final empty = Event(
    id: '',
    title: '',
    description: '',
    speaker: '',
    registeredUsers: List.empty(),
    registrationAmount: 0,
    date: Timestamp.now(),
    authorId: '',
    groupId: '',
  );

  Map<String, dynamic> toDocument() {
    return {
      'title': this.title,
      'description': this.description,
      'speaker': this.speaker,
      'registrationAmount': this.registrationAmount,
      'registeredUsers': this.registeredUsers,
      'date': this.date,
      'authorId': this.authorId,
      'groupId': groupId,
    };
  }

  static Event fromDocument(DocumentSnapshot doc) {
    if (doc == null) return null;
    final data = doc.data() as Map;

    final registeredUsers = data['registeredUsers'] != null
        ? List.from(data['registeredUsers']).map((e) => e.toString()).toList()
        : List<String>.empty();
    return Event(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      speaker: data['speaker'] ?? '',
      registeredUsers: registeredUsers,
      registrationAmount: data['registrationAmount'] ?? 0,
      date: data['date'] ?? Timestamp.now(),
      authorId: data['authorId'] ?? '',
      groupId: data['groupId'] ?? '',
    );
  }

  @override
  List<Object> get props => [
        id,
        title,
        description,
        speaker,
        registrationAmount,
        registeredUsers,
        date,
        authorId,
        groupId
      ];

  Event copyWith({
    String id,
    String title,
    String description,
    String groupId,
    String authorId,
    List<String> registeredUsers,
    int registrationAmount,
    String speaker,
    Timestamp date,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      groupId: groupId ?? this.groupId,
      authorId: authorId ?? this.authorId,
      registeredUsers: registeredUsers ?? this.registeredUsers,
      registrationAmount: registrationAmount ?? this.registrationAmount,
      speaker: speaker ?? this.speaker,
      date: date ?? this.date,
    );
  }
}
