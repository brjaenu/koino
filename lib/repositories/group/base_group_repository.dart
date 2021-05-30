import 'package:koino/models/group_model.dart';

abstract class BaseGroupRepository {
  Future<Group> findById({String id});
  Stream<List<Future<Group>>> findByUserId({String userId});
}
