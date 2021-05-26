import 'package:koino/models/user_model.dart';

abstract class BaseUserRepository {
  Future<User> findById({String id});
}
