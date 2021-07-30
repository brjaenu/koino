import 'package:koino/models/models.dart';

abstract class BaseEventRepository {
  Future<List<Event>> findByGroupId({String groupId});
  Stream<List<Event>> streamByGroupId({String groupId});
  Stream<Event> streamByEventId({String eventId});

  Future<void> registerToEvent({String eventId, String userId, String username});
  Future<void> unregisterFromEvent({String eventId, String userId});
}
