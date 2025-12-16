import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/session_model.dart';

class SessionRepository {
  final _db = FirebaseFirestore.instance;
  final _collection = 'sessions';

  /// STREAM DES SÉANCES
  Stream<List<SessionModel>> getSessions() {
    return _db
        .collection(_collection)
        .orderBy('startTime')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(SessionModel.fromFirestore).toList(),
        );
  }

  /// ➕ AJOUT AVEC CONTRÔLE DE CONFLIT
  Future<void> addSession(SessionModel session) async {
    final conflict = await _hasConflict(session);

    if (conflict) {
      throw Exception(
        'Conflit : une séance existe déjà dans cette salle à cette heure',
      );
    }

    await _db.collection(_collection).add(session.toMap());
  }

  /// ✏️ UPDATE AVEC CONTRÔLE
  Future<void> updateSession(SessionModel session) async {
    final conflict = await _hasConflict(session, ignoreId: session.id);

    if (conflict) {
      throw Exception(
        'Conflit : une séance existe déjà dans cette salle à cette heure',
      );
    }

    await _db
        .collection(_collection)
        .doc(session.id)
        .update(session.toMap());
  }

  /// 🗑 DELETE
  Future<void> deleteSession(String id) async {
    await _db.collection(_collection).doc(id).delete();
  }

  /// 🔒 VÉRIFICATION DE CHEVAUCHEMENT
  Future<bool> _hasConflict(
    SessionModel newSession, {
    String? ignoreId,
  }) async {
    final query = await _db
        .collection(_collection)
        .where('salle', isEqualTo: newSession.salle)
        .get();

    for (final doc in query.docs) {
      if (ignoreId != null && doc.id == ignoreId) continue;

      final existing = SessionModel.fromFirestore(doc);

      final overlap =
          newSession.startTime.isBefore(existing.endTime) &&
          newSession.endTime.isAfter(existing.startTime);

      if (overlap) return true;
    }

    return false;
  }
}
