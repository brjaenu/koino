part of 'prayer_bloc.dart';

class PrayerEvent extends Equatable {
  const PrayerEvent();

  @override
  List<Object> get props => [];
}

class EventCreatePrayerStream extends PrayerEvent {}

class EventProcessPrayerStream extends PrayerEvent {
  final List<Prayer> prayers;

  EventProcessPrayerStream({
    @required this.prayers,
  });

  @override
  List<Object> get props => [prayers];
}

class EventFetchPrayers extends PrayerEvent {}

class EventPrayForPrayer extends PrayerEvent {
  final String prayerId;
  final String userId;

  EventPrayForPrayer({
    @required this.prayerId,
    @required this.userId,
  });

  @override
  List<Object> get props => [prayerId, userId];
}

class EventDeletePrayer extends PrayerEvent {
  final String prayerId;
  final String authorId;

  EventDeletePrayer({
    @required this.prayerId,
    @required this.authorId,
  });

  @override
  List<Object> get props => [prayerId, authorId];
}
