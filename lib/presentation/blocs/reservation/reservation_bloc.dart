import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/reservation_repository.dart';
import 'reservation_event.dart';
import 'reservation_state.dart';

class ReservationBloc
    extends Bloc<ReservationEvent, ReservationState> {
  final ReservationRepository repository;

  ReservationBloc(this.repository)
      : super(ReservationInitial()) {
    on<AddReservation>(_addReservation);
    on<LoadMyReservations>(_loadMyReservations);
  }

  Future<void> _addReservation(
    AddReservation event,
    Emitter<ReservationState> emit,
  ) async {
    try {
      await repository.addReservation(event.reservation);
    } catch (e) {
      emit(ReservationError("Erreur lors du paiement"));
    }
  }

  Future<void> _loadMyReservations(
    LoadMyReservations event,
    Emitter<ReservationState> emit,
  ) async {
    emit(ReservationLoading());
    try {
      final reservations =
          await repository.getMyReservations(event.userId);
      emit(ReservationLoaded(reservations));
    } catch (e) {
      emit(ReservationError("Erreur chargement tickets"));
    }
  }
}
