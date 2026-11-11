import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mero_focus/features/pomodoro/domain/usecases/complete_session.dart';
import 'package:mero_focus/features/pomodoro/domain/usecases/pause_session.dart';
import 'package:mero_focus/features/pomodoro/domain/usecases/start_session.dart';
import 'package:mero_focus/features/pomodoro/presentation/cubit/pomodoro_state.dart';

/// Drives the pomodoro timer screen.
class PomodoroCubit extends Cubit<PomodoroState> {
  PomodoroCubit({
    required StartSession startSession,
    required PauseSession pauseSession,
    required CompleteSession completeSession,
  }) : _startSession = startSession,
       _pauseSession = pauseSession,
       _completeSession = completeSession,
       super(const PomodoroInitial());

  final StartSession _startSession;
  final PauseSession _pauseSession;
  final CompleteSession _completeSession;

  // TODO: start a focus session.
  Future<void> start() => throw UnimplementedError();

  // TODO: pause the running session.
  Future<void> pause() => throw UnimplementedError();

  // TODO: resume a paused session.
  Future<void> resume() => throw UnimplementedError();

  // TODO: complete the session and store it.
  Future<void> complete() => throw UnimplementedError();
}
