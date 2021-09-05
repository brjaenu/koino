part of 'create_prayer_cubit.dart';

enum CreatePrayerStatus { initial, submitting, success, error }

class CreatePrayerState extends Equatable {
  final String title;
  final String description;
  final bool isAnonymous;
  final CreatePrayerStatus status;
  final Failure failure;

  const CreatePrayerState({
    @required this.title,
    @required this.description,
    @required this.isAnonymous,
    @required this.status,
    @required this.failure,
  });

  bool get isFormValid =>
      title.isNotEmpty &&
      title.length >= 3 &&
      description.isNotEmpty &&
      description.length >= 5 &&
      isAnonymous != null;

  factory CreatePrayerState.initial() {
    return CreatePrayerState(
      title: '',
      description: '',
      isAnonymous: false,
      status: CreatePrayerStatus.initial,
      failure: const Failure(),
    );
  }
  @override
  List<Object> get props => [title, description, isAnonymous, status, failure];

  CreatePrayerState copyWith({
    String title,
    String description,
    bool isAnonymous,
    CreatePrayerStatus status,
    Failure failure,
  }) {
    return CreatePrayerState(
      title: title ?? this.title,
      description: description ?? this.description,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
