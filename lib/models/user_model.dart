import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String email;

  const User({
    @required this.id,
    @required this.username,
    @required this.email,
  });

  static const empty = User(id: '', username: '', email: '');

  Map<String, dynamic> toDocument() {
    return {
      'username': this.username,
      'email': this.email,
    };
  }

  factory User.fromDocument(DocumentSnapshot doc) {
    if (doc == null) return null;
    final data = doc.data() as Map;
    return User(
      id: doc.id,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
    );
  }

  @override
  List<Object> get props => [
        id,
        username,
        email,
      ];

  User copyWith({
    String id,
    String username,
    String email,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
    );
  }
}
