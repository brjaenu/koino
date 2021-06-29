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
        .collection(Paths.GROUPS)
        .doc(groupId)
        .collection(Paths.EVENTS)
        .orderBy('date', descending: false)
        .startAt([DateTime.now()]).get();
    return eventsSnap.docs.isNotEmpty
        ? eventsSnap.docs
            .map((doc) => Event.fromDocument(doc))
            .toList()
        : List.empty();
  }
}
