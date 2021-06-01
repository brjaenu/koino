import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:koino/models/user_model.dart';
import 'package:koino/util/paths.dart';

class Group extends Equatable {
  final String id;
  final String name;
  final User owner;

  const Group({
    this.id,
    @required this.name,
    @required this.owner,
  });

  static const empty =
      Group(id: '', name: '', owner: User.empty);

  Map<String, dynamic> toDocument() {
    return {
      'name': this.name,
      'owner': FirebaseFirestore.instance.collection(Paths.USERS).doc(owner.id),
    };
  }

  static Future<Group> fromDocument(DocumentSnapshot doc) async {
    if (doc == null) return null;
    final data = doc.data() as Map;
    final ownerRef = data['owner'] as DocumentReference;

    if (ownerRef != null ) {
      final ownerDoc = await ownerRef.get();
      if (ownerDoc != null) {
        return Group(
          id: doc.id,
          name: data['name'] ?? '',
          owner: User.fromDocument(ownerDoc),
        );
      }
    }
    return null;
  }

  @override
  List<Object> get props => [
        id,
        name,
      ];

  Group copyWith({
    String id,
    String name,
    User owner,
    int memberAmount,
    List<User> members,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      owner: owner ?? this.owner,
    );
  }
}
