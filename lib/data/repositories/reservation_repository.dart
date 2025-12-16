import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/reservation_model.dart';

class ReservationRepository {
  final _db = FirebaseFirestore.instance.collection('reservations');

  Future<void> addReservation(ReservationModel reservation) async {
    await _db.add(reservation.toMap());
  }

  Stream<List<ReservationModel>> getUserReservations(String userId) {
    return _db
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ReservationModel.fromFirestore(doc))
            .toList());
  }
}
