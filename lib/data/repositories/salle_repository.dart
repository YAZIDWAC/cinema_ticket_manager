import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/salle_model.dart';

class SalleRepository {
  final _collection = FirebaseFirestore.instance.collection('salles');

  Stream<List<SalleModel>> getSalles() {
    return _collection.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => SalleModel.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }

  Future<void> addSalle(SalleModel salle) async {
    await _collection.add(salle.toMap());
  }

  Future<void> updateSalle(SalleModel salle) async {
    await _collection.doc(salle.id).update(salle.toMap());
  }

  Future<void> deleteSalle(String id) async {
    await _collection.doc(id).delete();
  }
}
