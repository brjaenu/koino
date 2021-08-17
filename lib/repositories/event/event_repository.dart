import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:koino/models/models.dart';
import 'package:koino/util/paths.dart';

import 'base_event_repository.dart';

class EventRepository extends BaseEventRepository {
  final FirebaseFirestore _firebaseFirestore;

  EventRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<List<Event>> findByGroupId({@required String groupId}) async {
    final eventsSnap = await _firebaseFirestore
        .collection(Paths.EVENTS)
        .where('groupId', isEqualTo: groupId)
        .orderBy('date', descending: false)
        .startAt([DateTime.now()]).get();
    return eventsSnap.docs.isNotEmpty
        ? eventsSnap.docs.map((doc) => Event.fromDocument(doc)).toList()
        : List.empty();
  }

  @override
  Stream<List<Event>> streamByGroupId({String groupId}) {
    return _firebaseFirestore
        .collection(Paths.EVENTS)
        .where('groupId', isEqualTo: groupId)
        .orderBy('date', descending: false)
        .startAt([DateTime.now()])
        .snapshots()
        .map((s) => s.docs.map((d) => Event.fromDocument(d)).toList());
  }

  @override
  Stream<Event> streamByEventId({String eventId}) {
    return _firebaseFirestore
        .collection(Paths.EVENTS)
        .doc(eventId)
        .snapshots()
        .map((d) => Event.fromDocument(d));
  }

  @override
  Future<void> registerToEvent(
      {String eventId, String userId, String username}) async {
    final registrationRef = await _firebaseFirestore
        .collection(Paths.EVENTS)
        .doc(eventId)
        .collection(Paths.REGISTRATIONS);
    return registrationRef.doc(userId).set({
      'additionalAmount': 0,
      'username': username,
    });
  }

  @override
  Future<void> unregisterFromEvent({String eventId, String userId}) async {
    final registrationRef = await _firebaseFirestore
        .collection(Paths.EVENTS)
        .doc(eventId)
        .collection(Paths.REGISTRATIONS);
    return registrationRef.doc(userId).delete();
  }

  @override
  Future<Event> create({
    String title,
    String description,
    String speaker,
    Timestamp date,
    String authorId,
    String groupId,
  }) async {
    final userRef = _firebaseFirestore.collection(Paths.USERS).doc(authorId);
    final eventRef = await _firebaseFirestore.collection(Paths.EVENTS).add({
      'title': title,
      'description': description,
      'speaker': speaker,
      'date': date,
      'groupId': groupId,
      'author': userRef,
      'registeredUsers': [],
      'registrationAmount': 0
    });
    final doc = await eventRef.get();
    return doc.exists ? Event.fromDocument(doc) : null;
  }
}
