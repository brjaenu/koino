part of 'prayer_bloc.dart';

enum PrayerStatus { initial, loading, loaded, error }

class PrayerState extends Equatable {
  final List<Prayer> prayers;
  final PrayerStatus status;
  final Failure failure;

  const PrayerState({
    @required this.prayers,
    @required this.status,
    @required this.failure,
  });

  factory PrayerState.initial() {
    return PrayerState(
      prayers: [],
      status: PrayerStatus.initial,
      failure: null,
    );
  }

  @override
  List<Object> get props => [prayers, status, failure];

  PrayerState copyWith({
    List<Prayer> prayers,
    PrayerStatus status,
    Failure failure,
  }) {
    return PrayerState(
      prayers: prayers ?? this.prayers,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
