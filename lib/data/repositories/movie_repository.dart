import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/movie_model.dart';

class MovieRepository {
  final CollectionReference _movies =
      FirebaseFirestore.instance.collection('movies');

  /// 🔥 RÉCUPÉRATION DES FILMS
  Future<List<MovieModel>> getMovies() async {
    try {
      final snapshot = await _movies.get();

      return snapshot.docs
          .map((doc) => MovieModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('🔥 Firestore getMovies error: $e');
      rethrow;
    }
  }

  Future<void> addMovie(MovieModel movie) async {
    await _movies.add(movie.toMap());
  }

  Future<void> updateMovie(MovieModel movie) async {
    await _movies.doc(movie.id).update(movie.toMap());
  }

  Future<void> deleteMovie(String id) async {
    await _movies.doc(id).delete();
  }
}
