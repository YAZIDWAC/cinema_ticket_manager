import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/movie_model.dart';

class MovieRepository {
  final _db = FirebaseFirestore.instance.collection('movies');

  Future<List<MovieModel>> getMovies() async {
    final snapshot = await _db.get();
    return snapshot.docs
        .map((doc) => MovieModel.fromFirestore(doc))
        .toList();
  }

  Future<void> addMovie(MovieModel movie) async {
    await _db.add(movie.toMap());
  }

  Future<void> updateMovie(MovieModel movie) async {
    await _db.doc(movie.id).update(movie.toMap());
  }

  Future<void> deleteMovie(String id) async {
    await _db.doc(id).delete();
  }
}
