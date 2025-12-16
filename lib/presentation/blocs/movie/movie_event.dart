import '../../../domain/models/movie_model.dart';

abstract class MovieEvent {}

class LoadMovies extends MovieEvent {}

class AddMovie extends MovieEvent {
  final MovieModel movie;
  AddMovie(this.movie);
}

class UpdateMovie extends MovieEvent {
  final MovieModel movie;
  UpdateMovie(this.movie);
}

class DeleteMovie extends MovieEvent {
  final String id;
  DeleteMovie(this.id);
}
