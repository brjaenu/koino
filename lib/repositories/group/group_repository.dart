import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:koino/models/models.dart';
import 'package:koino/util/paths.dart';

import 'base_group_repository.dart';

class GroupRepository extends BaseGroupRepository {
  final FirebaseFirestore _firebaseFirestore;

  GroupRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<Group> findById({@required String id}) async {
    final doc = await _firebaseFirestore.collection(Paths.GROUPS).doc(id).get();
    return doc.exists ? Group.fromDocument(doc) : Group.empty;
  }

  @override
  Stream<List<Future<Group>>> findByUserId({String userId}) {
    final userRef = _firebaseFirestore.collection(Paths.USERS).doc(userId);
    return _firebaseFirestore
        .collection(Paths.GROUPS)
        .where('members', arrayContains: userRef)
        .snapshots()
        .map(
            (snap) => snap.docs.map((doc) => Group.fromDocument(doc)).toList());
  }
}
