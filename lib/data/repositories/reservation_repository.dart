import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/reservation_model.dart';

class ReservationRepository {
  final _db = FirebaseFirestore.instance;

  Future<void> addReservation(ReservationModel reservation) async {
    final batch = _db.batch();

    final reservationRef = _db.collection('reservations').doc();
    final sessionRef =
        _db.collection('sessions').doc(reservation.sessionId);

    batch.set(reservationRef, reservation.toMap());
    batch.update(sessionRef, {
      'reservedSeats': FieldValue.increment(reservation.tickets),
    });

    await batch.commit();
  }

  Stream<List<ReservationModel>> getUserReservations(String userId) {
    return _db
        .collection('reservations')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map(ReservationModel.fromFirestore).toList());
  }
}
