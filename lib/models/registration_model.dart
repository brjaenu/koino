import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Registration extends Equatable {
  final String id;
  final String username;
  final int additionalAmount;

  const Registration({
    @required this.id,
    @required this.username,
    @required this.additionalAmount,
  });

  static final empty = Registration(
    id: '',
    username: '',
    additionalAmount: 0,
  );

  Map<String, dynamic> toDocument() {
    return {
      'additionalAmount': this.additionalAmount,
      'username': this.username,
    };
  }

  static Registration fromDocument(DocumentSnapshot doc) {
    if (doc == null) return null;
    final data = doc.data() as Map;
    return Registration(
      id: doc.id,
      username: data['username'] ?? '',
      additionalAmount: data['additionalAmount'] ?? 0,
    );
  }

  @override
  List<Object> get props => [
        id,
        username,
        additionalAmount,
      ];

  Registration copyWith({
    String id,
    String username,
    int additionalAmount,
  }) {
    return Registration(
      id: id ?? this.id,
      username: username ?? this.username,
      additionalAmount: additionalAmount ?? this.additionalAmount,
    );
  }
}
