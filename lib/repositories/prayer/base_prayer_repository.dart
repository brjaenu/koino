import 'package:koino/models/models.dart';

abstract class BasePrayerRepository {
  Future<List<Prayer>> findByGroupId({String groupId});
  Stream<List<Prayer>> streamByGroupId({String groupId});

  Future<void> prayForPrayer({String prayerId, String userId});

  Future<Prayer> create({
    String title,
    String description,
    bool isAnonymous,
    String username,
    String authorId,
    String groupId,
  });

  Future<void> removePrayer({String prayerId});
}
