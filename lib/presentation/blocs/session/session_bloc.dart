import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/session_repository.dart';
import 'session_event.dart';
import 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final SessionRepository repository;

  SessionBloc(this.repository) : super(SessionInitial()) {
    on<LoadSessions>(_onLoadSessions);
    on<AddSession>(_onAddSession);
    on<UpdateSession>(_onUpdateSession);
    on<DeleteSession>(_onDeleteSession);
  }

  Future<void> _onLoadSessions(
    LoadSessions event,
    Emitter<SessionState> emit,
  ) async {
    emit(SessionLoading());

    await emit.forEach(
      repository.getSessions(),
      onData: (sessions) => SessionLoaded(sessions),
      onError: (e, _) => SessionError(e.toString()),
    );
  }

  Future<void> _onAddSession(
    AddSession event,
    Emitter<SessionState> emit,
  ) async {
    await repository.addSession(event.session);
  }

  Future<void> _onUpdateSession(
    UpdateSession event,
    Emitter<SessionState> emit,
  ) async {
    await repository.updateSession(event.session);
  }

  Future<void> _onDeleteSession(
    DeleteSession event,
    Emitter<SessionState> emit,
  ) async {
    await repository.deleteSession(event.id);
  }
}
