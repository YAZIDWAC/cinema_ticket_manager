import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/movie_repository.dart';
import '../../../domain/models/movie_model.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository repository;

  MovieBloc(this.repository) : super(MovieInitial()) {
    on<LoadMovies>(_onLoadMovies);
    on<AddMovie>(_onAddMovie);
    on<UpdateMovie>(_onUpdateMovie);
    on<DeleteMovie>(_onDeleteMovie);
  }

  Future<void> _onLoadMovies(
    LoadMovies event,
    Emitter<MovieState> emit,
  ) async {
    emit(MovieLoading());
    try {
      final movies = await repository.getMovies();
      emit(MovieLoaded(movies));
    } catch (e) {
      emit(MovieError(e.toString()));
    }
  }

  Future<void> _onAddMovie(AddMovie event, Emitter<MovieState> emit) async {
    await repository.addMovie(event.movie);
    add(LoadMovies());
  }

  Future<void> _onUpdateMovie(UpdateMovie event, Emitter<MovieState> emit) async {
    await repository.updateMovie(event.movie);
    add(LoadMovies());
  }

  Future<void> _onDeleteMovie(DeleteMovie event, Emitter<MovieState> emit) async {
    await repository.deleteMovie(event.id);
    add(LoadMovies());
  }
}
