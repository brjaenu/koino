import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Registration extends Equatable {
  final String id;
  final int additionalAmount;

  const Registration({
    @required this.id,
    @required this.additionalAmount,
  });

  static final empty = Registration(
    id: '',
    additionalAmount: 0,
  );

  Map<String, dynamic> toDocument() {
    return {
      'additionalAmount': this.additionalAmount,
    };
  }

  static Registration fromDocument(DocumentSnapshot doc) {
    if (doc == null) return null;
    final data = doc.data() as Map;
    return Registration(
      id: doc.id,
      additionalAmount: data['additionalAmount'] ?? 0,
    );
  }

  @override
  List<Object> get props => [
        id,
        additionalAmount,
      ];

  Registration copyWith({
    String id,
    int additionalAmount,
  }) {
    return Registration(
      id: id ?? this.id,
      additionalAmount: additionalAmount ?? this.additionalAmount,
    );
  }
}
