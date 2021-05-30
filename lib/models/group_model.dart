import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:koino/models/user_model.dart';
import 'package:koino/util/paths.dart';

class Group extends Equatable {
  final String id;
  final String name;
  final User owner;
  final int memberAmount;
  final List<User> members;

  const Group({
    this.id,
    @required this.name,
    @required this.owner,
    @required this.memberAmount,
    @required this.members,
  });

  static const empty =
      Group(id: '', name: '', owner: User.empty, memberAmount: 0, members: []);

  Map<String, dynamic> toDocument() {
    return {
      'name': this.name,
      'owner': FirebaseFirestore.instance.collection(Paths.USERS).doc(owner.id),
      'memberAmount': this.memberAmount,
      'members': this
          .members
          .map((user) =>
              FirebaseFirestore.instance.collection(Paths.USERS).doc(user.id))
          .toList(),
    };
  }

  static Future<Group> fromDocument(DocumentSnapshot doc) async {
    if (doc == null) return null;
    final data = doc.data() as Map;
    final ownerRef = data['owner'] as DocumentReference;

    final List<DocumentReference> membersRefs = (data['members'] as List<dynamic>).map<DocumentReference>((r) => r).toList();

    if (ownerRef != null && membersRefs != null) {
      final ownerDoc = await ownerRef.get();
      final memberDocs =
          await Future.wait(membersRefs.map((memberRef) => memberRef.get()).toList());

      if (ownerDoc != null && memberDocs != null) {
        return Group(
          id: doc.id,
          name: data['name'] ?? '',
          owner: User.fromDocument(ownerDoc),
          memberAmount: (data['memberAmount'] ?? 0).toInt(),
          members: await memberDocs
              .map((memberDoc) => User.fromDocument(memberDoc))
              .toList(),
        );
      }
    }
    return null;
  }

  @override
  List<Object> get props => [
        id,
        name,
        memberAmount,
        members,
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
      memberAmount: memberAmount ?? this.memberAmount,
      members: members ?? this.members,
    );
  }
}
