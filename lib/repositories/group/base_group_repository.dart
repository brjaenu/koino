import 'package:koino/models/group_model.dart';

abstract class BaseGroupRepository {
  Future<Group> findById({String id});
  Stream<List<Group>> findByUserId({String userId});
  Future<Group> findActiveGroupByUserId({String userId});
}
