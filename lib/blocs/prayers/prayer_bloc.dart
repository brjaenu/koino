import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:koino/blocs/user/user_bloc.dart';
import 'package:koino/models/models.dart';
import 'package:koino/repositories/repositories.dart';

part 'prayer_event.dart';
part 'prayer_state.dart';

class PrayerBloc extends Bloc<PrayerEvent, PrayerState> {
  final PrayerRepository _prayerRepository;
  final UserBloc _userBloc;

  StreamSubscription<List<Prayer>> _prayersSubscription;

  PrayerBloc({
    @required PrayerRepository prayerRepository,
    @required UserBloc userBloc,
  })  : _prayerRepository = prayerRepository,
        _userBloc = userBloc,
        super(PrayerState.initial());

  @override
  Future<void> close() {
    _prayersSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<PrayerState> mapEventToState(
    PrayerEvent event,
  ) async* {
    if (event is EventCreatePrayerStream) {
      yield* _mapEventCreatePrayerStreamToState();
    } else if (event is EventProcessPrayerStream) {
      yield* _mapEventProcessPrayerStreamToState(event);
    } else if (event is EventFetchPrayers) {
      yield* _mapEventFetchPrayersToState();
    }
  }

  Stream<PrayerState> _mapEventCreatePrayerStreamToState() async* {
    _prayersSubscription?.cancel();
    _prayersSubscription = _prayerRepository
        .streamByGroupId(groupId: _userBloc.state.user.activeGroup.id)
        .listen((prayers) async {
      add(EventProcessPrayerStream(prayers: prayers));
    });
  }

  Stream<PrayerState> _mapEventProcessPrayerStreamToState(
      EventProcessPrayerStream event) async* {
    yield state.copyWith(
      prayers: event.prayers,
    );
  }

  Stream<PrayerState> _mapEventFetchPrayersToState() async* {
    yield state
        .copyWith(prayers: [], status: PrayerStatus.loading, failure: null);
    try {
      final prayers = await _prayerRepository.findByGroupId(
          groupId: _userBloc.state.user.activeGroup.id);

      yield state.copyWith(
        prayers: prayers,
        status: PrayerStatus.loaded,
      );
    } catch (err) {
      print(err);
      yield state.copyWith(
        status: PrayerStatus.error,
        failure: const Failure(message: 'Unable to load prayers'),
      );
    }
  }
}
