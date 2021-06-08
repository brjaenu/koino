import 'package:koino/models/group_model.dart';

abstract class BaseGroupRepository {
  Stream<List<Group>> findByUserId({String userId});
  Future<Group> create({String name, String activationCode, String ownerId});
}
