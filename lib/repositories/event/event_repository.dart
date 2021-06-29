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
  Future<void> registerToEvent({String eventId, String userId}) async {
    final registrationRef = await _firebaseFirestore
        .collection(Paths.EVENTS)
        .doc(eventId)
        .collection(Paths.REGISTRATIONS);
    return registrationRef.doc(userId).set({
      'additionalAmount': 0,
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
}
