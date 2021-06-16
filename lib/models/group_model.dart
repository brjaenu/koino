import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Group extends Equatable {
  final String id;
  final String name;
  final String ownerId;
  final String activationCode;

  const Group({
    this.id,
    @required this.name,
    @required this.ownerId,
    @required this.activationCode,
  });

  static const empty = Group(id: '', name: '', ownerId: '', activationCode: '');

  Map<String, dynamic> toDocument() {
    return {
      'name': this.name,
      'ownerId': ownerId,
      'activationCode': activationCode,
    };
  }

  factory Group.fromDocument(DocumentSnapshot doc) {
    if (doc == null) return null;
    final data = doc.data() as Map;

    return Group(
      id: doc.id,
      name: data['name'] ?? '',
      ownerId: data['owner'] ?? '',
      activationCode: data['activationCode'] ?? '',
    );
  }

  @override
  List<Object> get props => [id, name, ownerId, activationCode];

  Group copyWith({
    String id,
    String name,
    String ownerId,
    String activationCode,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      activationCode: activationCode ?? this.activationCode,
    );
  }
}
