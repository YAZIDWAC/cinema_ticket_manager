import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/reservation_model.dart';

class ReservationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addReservation(ReservationModel reservation) async {
    final batch = _firestore.batch();

    final sessionRef =
        _firestore.collection('sessions').doc(reservation.sessionId);

    final reservationRef =
        _firestore.collection('reservations').doc();

    batch.set(
      reservationRef,
      reservation.toJson(),
    );

    batch.update(
      sessionRef,
      {
        'remainingSeats':
            FieldValue.increment(-reservation.tickets),
      },
    );

    await batch.commit();
  }

  Future<List<ReservationModel>> getMyReservations(
    String userId,
  ) async {
    final snap = await _firestore
        .collection('reservations')
        .where('userId', isEqualTo: userId)
        .orderBy('startTime', descending: true)
        .get();

    return snap.docs
        .map(
          (doc) =>
              ReservationModel.fromJson(doc.data(), doc.id),
        )
        .toList();
  }
}
