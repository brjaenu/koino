part of 'create_event_cubit.dart';

enum CreateEventStatus { initial, submitting, success, error }

class CreateEventState extends Equatable {
  final String title;
  final String description;
  final String speaker;
  final Timestamp date;
  final CreateEventStatus status;
  final Failure failure;

  const CreateEventState({
    @required this.title,
    @required this.description,
    @required this.speaker,
    @required this.date,
    @required this.status,
    @required this.failure,
  });

  bool get isFormValid =>
      title.isNotEmpty &&
      title.length >= 3 &&
      description.isNotEmpty &&
      description.length >= 5 &&
      date.compareTo(Timestamp.now()) > 0;

  factory CreateEventState.initial() {
    return CreateEventState(
      title: '',
      description: '',
      speaker: '',
      date: Timestamp.now(),
      status: CreateEventStatus.initial,
      failure: const Failure(),
    );
  }

  @override
  List<Object> get props =>
      [title, description, speaker, date, status, failure];

  CreateEventState copyWith({
    String title,
    String description,
    String speaker,
    Timestamp date,
    CreateEventStatus status,
    Failure failure,
  }) {
    return CreateEventState(
      title: title ?? this.title,
      description: description ?? this.description,
      speaker: speaker ?? this.speaker,
      date: date ?? this.date,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
