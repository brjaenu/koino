import 'package:koino/models/group_model.dart';

abstract class BaseGroupRepository {
  Stream<List<Group>> findByUserId({String userId});
  Future<Group> findByNameAndActivationCode(
      {String name, String activationCode});
  Future<Group> create({String name, String activationCode, String ownerId});
  Future<void> addMember({String groupId, String userId});
}
