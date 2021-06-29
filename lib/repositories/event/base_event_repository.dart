import 'package:koino/models/models.dart';

abstract class BaseEventRepository {
  Future<List<Event>> findByGroupId({String groupId});
}
