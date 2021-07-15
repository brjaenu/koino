import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:koino/models/models.dart';
import 'package:koino/util/paths.dart';

import 'base_registration_repository.dart';

class RegistrationRepository extends BaseRegistrationRepository {
  final FirebaseFirestore _firebaseFirestore;

  RegistrationRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Registration>> findByEventIdStream(
      {String eventId}) {
    return _firebaseFirestore
        .collection(Paths.EVENTS)
        .doc(eventId)
        .collection(Paths.REGISTRATIONS)
        .snapshots()
        .map((s) => s.docs.map((d) => Registration.fromDocument(d)).toList());
  }
}
