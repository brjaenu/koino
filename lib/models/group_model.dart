import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:koino/models/user_model.dart';

class Group extends Equatable {
  final String id;
  final String name;
  final String ownerId;

  const Group({
    this.id,
    @required this.name,
    @required this.ownerId,
  });

  static const empty = Group(id: '', name: '', ownerId: '');

  Map<String, dynamic> toDocument() {
    return {
      'name': this.name,
      'ownerId': ownerId,
    };
  }

  factory Group.fromDocument(DocumentSnapshot doc) {
    if (doc == null) return null;
    final data = doc.data() as Map;

    return Group(
      id: doc.id,
      name: data['name'] ?? '',
      ownerId: data['ownerId'] ?? '',
    );
  }

  @override
  List<Object> get props => [id, name, ownerId];

  Group copyWith({
    String id,
    String name,
    String ownerId,
    int memberAmount,
    List<User> members,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
    );
  }
}
