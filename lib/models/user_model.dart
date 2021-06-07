import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:koino/util/paths.dart';

import 'models.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String email;
  final Group activeGroup;

  const User({
    @required this.id,
    @required this.username,
    @required this.email,
    @required this.activeGroup,
  });

  static const empty =
      User(id: '', username: '', email: '', activeGroup: Group.empty);

  Map<String, dynamic> toDocument() {
    return {
      'username': this.username,
      'email': this.email,
      'activeGroup': FirebaseFirestore.instance
          .collection(Paths.GROUPS)
          .doc(this.activeGroup.id),
    };
  }

  static Future<User> fromDocument(DocumentSnapshot doc) async {
    if (doc == null) return null;
    final data = doc.data() as Map;
    final activeGroupRef = data['activeGroup'] as DocumentReference;

    if (activeGroupRef != null) {
      final activeGroupDoc = await activeGroupRef.get();
      if (activeGroupDoc != null) {
        return User(
          id: doc.id,
          username: data['username'] ?? '',
          email: data['email'] ?? '',
          activeGroup: await Group.fromDocument(activeGroupDoc),
        );
      }
    }
    return User(
        id: doc.id,
        username: data['username'] ?? '',
        email: data['email'] ?? '',
        activeGroup: null);
  }

  @override
  List<Object> get props => [id, username, email, activeGroup];

  User copyWith({
    String id,
    String username,
    String email,
    Group activeGroup,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      activeGroup: activeGroup ?? this.activeGroup,
    );
  }
}
