import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:koino/models/models.dart';

abstract class BaseEventRepository {
  Future<List<Event>> findByGroupId({String groupId});
  Stream<List<Event>> streamByGroupId({String groupId});
  Stream<Event> streamByEventId({String eventId});

  Future<void> registerToEvent(
      {String eventId, String userId, String username});
  Future<void> unregisterFromEvent({String eventId, String userId});

  Future<Event> create({
    String title,
    String description,
    String speaker,
    Timestamp date,
    String authorId,
    String groupId,
  });
}
