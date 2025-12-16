import '../../../domain/models/session_model.dart';

abstract class SessionEvent {}

class LoadSessions extends SessionEvent {}

class AddSession extends SessionEvent {
  final SessionModel session;
  AddSession({required this.session});
}

class UpdateSession extends SessionEvent {
  final SessionModel session;
  UpdateSession({required this.session});
}

class DeleteSession extends SessionEvent {
  final String id;
  DeleteSession(this.id);
}
