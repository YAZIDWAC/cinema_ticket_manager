import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/session_model.dart';

class SessionRepository {
  final CollectionReference _db =
      FirebaseFirestore.instance.collection('sessions');

  /// 🔁 STREAM DES SÉANCES
  Stream<List<SessionModel>> getSessions() {
    return _db.snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => SessionModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// ➕ AJOUT
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

  /// ✏️ MODIFICATION
  Future<void> updateSession({
    required String id,
    required String movieTitle,
    required String salle,
    required String date,
    required String time,
    required int price,
  }) async {
    await _db.doc(id).update({
      'movieTitle': movieTitle,
      'salle': salle,
      'date': date,
      'time': time,
      'price': price,
    });
  }

  /// 🗑 SUPPRESSION
  Future<void> deleteSession(String id) async {
    await _db.doc(id).delete();
  }
}
