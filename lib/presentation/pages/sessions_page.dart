import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/session/session_bloc.dart';
import '../blocs/session/session_state.dart';
import '../blocs/session/session_event.dart';
import '../../domain/models/session_model.dart';
import 'add_reservation_page.dart';

class SessionsPage extends StatelessWidget {
  final bool isAdmin;
  final String? movieTitle;

  const SessionsPage({
    Key? key,
    required this.isAdmin,
    this.movieTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Séances")),
      body: BlocBuilder<SessionBloc, SessionState>(
        builder: (context, state) {
          if (state is SessionLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SessionLoaded) {
            List<SessionModel> sessions = state.sessions;

            if (movieTitle != null) {
              sessions = sessions
                  .where((s) => s.movieTitle == movieTitle)
                  .toList();
            }

            if (sessions.isEmpty) {
              return const Center(child: Text("Aucune séance disponible"));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      session.movieTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Salle : ${session.salle}"),
                        Text("Date : ${session.date}"),
                        Text("Heure : ${session.time}"),
                        Text("Prix : ${session.price} DH"),
                      ],
                    ),
                    trailing: isAdmin
                        ? IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              context
                                  .read<SessionBloc>()
                                  .add(DeleteSession(session.id));
                            },
                          )
                        : ElevatedButton(
                            child: const Text("Réserver"),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AddReservationPage(session: session),
                                ),
                              );
                            },
                          ),
                  ),
                );
              },
            );
          }

          if (state is SessionError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
