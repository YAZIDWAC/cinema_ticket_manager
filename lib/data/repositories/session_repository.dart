import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/session_model.dart';

class SessionRepository {
  final _db = FirebaseFirestore.instance.collection('sessions');

  Stream<List<SessionModel>> getSessions() {
    return _db
        .orderBy('startTime')
        .snapshots()
        .map((s) => s.docs.map(SessionModel.fromFirestore).toList());
  }

  Future<void> addSession(SessionModel session) async {
    if (await _hasConflict(session)) {
      throw Exception("⛔ Salle occupée à cet horaire");
    }
    await _db.add(session.toMap());
  }

  Future<void> updateSession(SessionModel session) async {
    if (await _hasConflict(session, ignoreId: session.id)) {
      throw Exception("⛔ Salle occupée à cet horaire");
    }
    await _db.doc(session.id).update(session.toMap());
  }

  Future<void> deleteSession(String id) async {
    await _db.doc(id).delete();
  }

  Future<bool> _hasConflict(
    SessionModel newSession, {
    String? ignoreId,
  }) async {
    final query =
        await _db.where('salle', isEqualTo: newSession.salle).get();

    for (final doc in query.docs) {
      if (ignoreId != null && doc.id == ignoreId) continue;

      final s = SessionModel.fromFirestore(doc);

      final overlap =
          newSession.startTime.isBefore(s.endTime) &&
          newSession.endTime.isAfter(s.startTime);

      if (overlap) return true;
    }
    return false;
  }
}
