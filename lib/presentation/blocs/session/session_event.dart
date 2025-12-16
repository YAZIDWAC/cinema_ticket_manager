import '../../../domain/models/session_model.dart';

abstract class SessionEvent {}

class LoadSessions extends SessionEvent {}

class AddSession extends SessionEvent {
  final SessionModel session;
  AddSession(this.session);
}

class UpdateSession extends SessionEvent {
  final String id;
  final SessionModel session;
  UpdateSession(this.id, this.session);
}

class DeleteSession extends SessionEvent {
  final String id;
  DeleteSession(this.id);
}
