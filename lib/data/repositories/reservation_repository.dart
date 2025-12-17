import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/reservation_model.dart';

class ReservationRepository {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  /// ➕ AJOUTER UNE RÉSERVATION
  Future<void> addReservation(
    ReservationModel reservation,
  ) async {
    final batch = _firestore.batch();

    // 🔹 Référence session
    final sessionRef = _firestore
        .collection('sessions')
        .doc(reservation.sessionId);

    // 🔹 Référence réservation (auto-ID)
    final reservationRef =
        _firestore.collection('reservations').doc();

    // 1️⃣ Créer réservation
    batch.set(
      reservationRef,
      reservation.toJson(),
    );

    // 2️⃣ Décrémenter les places
    batch.update(
      sessionRef,
      {
        'remainingSeats':
            FieldValue.increment(-reservation.tickets),
      },
    );

    // 🔥 COMMIT ATOMIQUE
    await batch.commit();
  }

  /// 🎟️ RÉSERVATIONS D’UN UTILISATEUR
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
          (doc) => ReservationModel.fromJson(
            doc.data(),
            doc.id,
          ),
        )
        .toList();
  }

  /// 🗑️ ANNULER RÉSERVATION (OPTIONNEL)
  Future<void> cancelReservation(
    ReservationModel reservation,
  ) async {
    final batch = _firestore.batch();

    final reservationRef = _firestore
        .collection('reservations')
        .doc(reservation.id);

    final sessionRef = _firestore
        .collection('sessions')
        .doc(reservation.sessionId);

    // 🔁 Rendre les places
    batch.update(
      sessionRef,
      {
        'remainingSeats':
            FieldValue.increment(reservation.tickets),
      },
    );

    // ❌ Supprimer réservation
    batch.delete(reservationRef);

    await batch.commit();
  }
}
