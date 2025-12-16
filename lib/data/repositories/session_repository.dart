import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/session_model.dart';

class SessionRepository {
  final _db = FirebaseFirestore.instance.collection('sessions');

  /// STREAM → mise à jour auto
  Stream<List<SessionModel>> getSessions() {
    return _db.snapshots().map(
          (snapshot) =>
              snapshot.docs.map((d) => SessionModel.fromFirestore(d)).toList(),
        );
  }

  Future<void> addSession({
    required String movieTitle,
    required String salle,
    required String date,
    required String time,
    required int price,
  }) async {
    await _db.add({
      'movieTitle': movieTitle,
      'salle': salle,
      'date': date,
      'time': time,
      'price': price,
    });
  }

  Future<void> deleteSession(String id) async {
    await _db.doc(id).delete();
  }

  Future<void> updateSession(String id, Map<String, dynamic> data) async {
    await _db.doc(id).update(data);
  }
}
