import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/reservation_repository.dart';
import 'reservation_event.dart';
import 'reservation_state.dart';

class ReservationBloc extends Bloc<ReservationEvent, ReservationState> {
  final ReservationRepository repository;

  ReservationBloc(this.repository) : super(ReservationInitial()) {
    on<AddReservation>(_onAddReservation);
    on<LoadMyReservations>(_onLoadMyReservations);
  }

  Future<void> _onAddReservation(
    AddReservation event,
    Emitter<ReservationState> emit,
  ) async {
    try {
      await repository.addReservation(event.reservation);
      emit(ReservationSuccess());
    } catch (e) {
      emit(ReservationError(e.toString()));
    }
  }

  Future<void> _onLoadMyReservations(
    LoadMyReservations event,
    Emitter<ReservationState> emit,
  ) async {
    emit(ReservationLoading());

    await emit.forEach(
      repository.getUserReservations(event.userId),
      onData: (data) => ReservationLoaded(data),
      onError: (e, _) => ReservationError(e.toString()),
    );
  }
}
