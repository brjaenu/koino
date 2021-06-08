import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:koino/models/models.dart';
import 'package:koino/util/paths.dart';

import 'base_group_repository.dart';

class GroupRepository extends BaseGroupRepository {
  final FirebaseFirestore _firebaseFirestore;

  GroupRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Group>> findByUserId({String userId}) {
    final userRef = _firebaseFirestore.collection(Paths.USERS).doc(userId);
    return _firebaseFirestore
        .collection(Paths.GROUPS)
        .where('members', arrayContains: userRef)
        .snapshots()
        .map(
            (snap) => snap.docs.map((doc) => Group.fromDocument(doc)).toList());
  }

  @override
  Future<Group> create(
      {String name, String activationCode, String ownerId}) async {
    final userRef = _firebaseFirestore.collection(Paths.USERS).doc(ownerId);
    final groupRef = await _firebaseFirestore.collection(Paths.GROUPS).add({
      'name': name,
      'activationCode': activationCode,
      'owner': userRef,
      'members': [userRef],
      'memberAmount': 1,
    });
    final doc = await groupRef.get();
    return doc.exists ? Group.fromDocument(doc) : Group.empty;
  }
}
