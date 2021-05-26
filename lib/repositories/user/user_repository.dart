import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:koino/models/user_model.dart';
import 'package:koino/repositories/user/base_user_repository.dart';
import 'package:koino/util/paths.dart';

class UserRepository extends BaseUserRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<User> findById({@required String id}) async {
    final doc = await _firebaseFirestore.collection(Paths.USERS).doc(id).get();
    return doc.exists ? User.fromDocument(doc) : User.empty;
  }
}
