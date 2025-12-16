import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/movie/movie_bloc.dart';
import '../blocs/movie/movie_event.dart';
import '../blocs/movie/movie_state.dart';

import 'add_movie_page.dart'; // ✅ OBLIGATOIRE

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  @override
  void initState() {
    super.initState();
    context.read<MovieBloc>().add(LoadMovies());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des films'),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddMoviePage(), // ✅ OK maintenant
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MovieLoaded) {
            if (state.movies.isEmpty) {
              return const Center(child: Text('Aucun film'));
            }

            return ListView.builder(
              itemCount: state.movies.length,
              itemBuilder: (context, index) {
                final movie = state.movies[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: movie.imageUrl.isNotEmpty
                        ? Image.network(
                            movie.imageUrl,
                            width: 50,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.movie),
                          )
                        : const Icon(Icons.movie),

                    title: Text(movie.title),

                    subtitle: Text(
                      'Durée: ${movie.duration} min\n'
                      '${movie.hasVF ? 'VF ' : ''}'
                      '${movie.hasVO ? 'VO ' : ''}'
                      '${movie.hasVOSTFR ? 'VOSTFR' : ''}',
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    AddMoviePage(movie: movie),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            context
                                .read<MovieBloc>()
                                .add(DeleteMovie(movie.id));
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          if (state is MovieError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
