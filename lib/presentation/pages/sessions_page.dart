import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/session/session_bloc.dart';
import '../blocs/session/session_event.dart';
import '../blocs/session/session_state.dart';
import 'add_session_page.dart';

class SessionsPage extends StatelessWidget {
  const SessionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<SessionBloc>().add(LoadSessions());

    return Scaffold(
      appBar: AppBar(title: const Text('Gestion des séances')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddSessionPage()),
          );
        },
      ),
      body: BlocBuilder<SessionBloc, SessionState>(
        builder: (context, state) {
          if (state is SessionLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SessionLoaded) {
            if (state.sessions.isEmpty) {
              return const Center(child: Text('Aucune séance'));
            }

            return ListView.builder(
              itemCount: state.sessions.length,
              itemBuilder: (context, index) {
                final s = state.sessions[index];

                return ListTile(
                  title: Text(s.movieTitle),
                  subtitle: Text(
                    '${s.salle} • ${s.date} • ${s.time} • ${s.price} DA',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      context
                          .read<SessionBloc>()
                          .add(DeleteSession(s.id));
                    },
                  ),
                );
              },
            );
          }

          return const Center(child: Text('Erreur'));
        },
      ),
    );
  }
}
