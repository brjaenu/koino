import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:koino/util/paths.dart';

import 'models.dart';

class Event extends Equatable {
  final String id;
  final String title;
  final String description;
  final String groupId;
  final String authorId;
  final Stream<List<Registration>> registrations;
  final int registrationAmount;
  final String speaker;
  final Timestamp date;

  const Event({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.speaker,
    @required this.registrations,
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
    registrations: Stream.value(List.empty()),
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
      'date': this.date,
      'authorId': this.authorId,
      'groupId': groupId,
    };
  }

  static Event fromDocument(DocumentSnapshot doc) {
    if (doc == null) return null;
    final data = doc.data() as Map;

    final regiSnap = doc.reference
        .collection(Paths.REGISTRATIONS)
        .snapshots()
        .map((snap) => snap.docs
            .map((regiDoc) => Registration.fromDocument(regiDoc))
            .toList());
            
    return Event(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      speaker: data['speaker'] ?? '',
      //registrations: Stream.value(List.empty()),
      registrations: regiSnap,
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
    Stream<List<Future<Registration>>> registrations,
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
      registrations: registrations ?? this.registrations,
      registrationAmount: registrationAmount ?? this.registrationAmount,
      speaker: speaker ?? this.speaker,
      date: date ?? this.date,
    );
  }
}
