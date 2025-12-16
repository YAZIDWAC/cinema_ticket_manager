abstract class SessionEvent {}

class LoadSessions extends SessionEvent {}

class AddSession extends SessionEvent {
  final String movieTitle;
  final String salle;
  final String date;
  final String time;
  final int price;

  AddSession({
    required this.movieTitle,
    required this.salle,
    required this.date,
    required this.time,
    required this.price,
  });
}

class UpdateSession extends SessionEvent {
  final String id;
  final String movieTitle;
  final String salle;
  final String date;
  final String time;
  final int price;

  UpdateSession({
    required this.id,
    required this.movieTitle,
    required this.salle,
    required this.date,
    required this.time,
    required this.price,
  });
}

class DeleteSession extends SessionEvent {
  final String id;
  DeleteSession(this.id);
}
