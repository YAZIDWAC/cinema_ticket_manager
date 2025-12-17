import '../../../domain/models/reservation_model.dart';
abstract class ReservationEvent {}

class AddReservation extends ReservationEvent {
  final ReservationModel reservation;

  AddReservation(this.reservation);
}

class LoadMyReservations extends ReservationEvent {
  final String userId;
  LoadMyReservations(this.userId);
}
