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
