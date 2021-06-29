import 'package:koino/models/models.dart';

abstract class BaseEventRepository {
  Future<List<Event>> findByGroupId({String groupId});

  Future<void> registerToEvent({String eventId, String userId});
  Future<void> unregisterFromEvent({String eventId, String userId});
}
