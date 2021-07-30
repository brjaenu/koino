import 'package:koino/models/models.dart';

abstract class BaseRegistrationRepository {
  Stream<List<Registration>> findByEventIdStream({String eventId});
}
