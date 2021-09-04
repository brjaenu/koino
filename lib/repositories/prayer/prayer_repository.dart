import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:koino/models/models.dart';
import 'package:koino/util/paths.dart';

import 'base_prayer_repository.dart';

class PrayerRepository extends BasePrayerRepository {
  final FirebaseFirestore _firebaseFirestore;

  PrayerRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<List<Prayer>> findByGroupId({@required String groupId}) async {
    final prayersSnap = await _firebaseFirestore
        .collection(Paths.PRAYERS)
        .where('groupId', isEqualTo: groupId)
        .orderBy('prayerAmount', descending: false)
        .get();
    return prayersSnap.docs.isNotEmpty
        ? prayersSnap.docs.map((doc) => Prayer.fromDocument(doc)).toList()
        : List.empty();
  }

  @override
  Stream<List<Prayer>> streamByGroupId({String groupId}) {
    return _firebaseFirestore
        .collection(Paths.PRAYERS)
        .where('groupId', isEqualTo: groupId)
        .orderBy('prayerAmount', descending: false)
        .snapshots()
        .map((s) => s.docs.map((d) => Prayer.fromDocument(d)).toList());
  }

  @override
  Future<void> prayForPrayer({String prayerId, String userId}) async {
    final registrationRef = await _firebaseFirestore
        .collection(Paths.PRAYERS)
        .doc(prayerId)
        .collection(Paths.USERS);
    return registrationRef.doc(userId).set({
      'timestamp': Timestamp.now(),
    });
  }

  @override
  Future<Prayer> create({
    String title,
    String description,
    bool isAnonymous,
    String username,
    String authorId,
    String groupId,
  }) async {
    final userRef = _firebaseFirestore.collection(Paths.USERS).doc(authorId);
    final prayerRef = await _firebaseFirestore.collection(Paths.PRAYERS).add({
      'title': title,
      'description': description,
      'isAnonymous': isAnonymous,
      'groupId': groupId,
      'author': userRef,
      'registeredUsers': [],
      'registrationAmount': 0,
      'creationTs': Timestamp.now(),
    });
    final doc = await prayerRef.get();
    return doc.exists ? Prayer.fromDocument(doc) : null;
  }
}
