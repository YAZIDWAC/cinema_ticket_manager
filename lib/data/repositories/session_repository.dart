import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/session_model.dart';

class SessionRepository {
  final CollectionReference _db =
      FirebaseFirestore.instance.collection('sessions');

  Stream<List<SessionModel>> getSessions() {
    return _db.snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => SessionModel.fromFirestore(doc))
              .toList(),
        );
  }

  Future<void> addSession(SessionModel session) async {
    await _db.add(session.toMap());
  }

  Future<void> updateSession(String id, SessionModel session) async {
    await _db.doc(id).update(session.toMap());
  }

  Future<void> deleteSession(String id) async {
    await _db.doc(id).delete();
  }
}
