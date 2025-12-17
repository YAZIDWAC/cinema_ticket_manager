import '../../../domain/models/reservation_model.dart';

abstract class ReservationEvent {}

class AddReservation extends ReservationEvent {
  final ReservationModel reservation;
  final int reservedTickets;

  AddReservation(
    this.reservation, {
    required this.reservedTickets,
  });
}

class LoadMyReservations extends ReservationEvent {
  final String userId;

  LoadMyReservations(this.userId);
}
