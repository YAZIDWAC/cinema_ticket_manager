import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/session/session_bloc.dart';
import '../blocs/session/session_state.dart';
import '../blocs/session/session_event.dart';

import '../../domain/models/session_model.dart';

import 'add_session_page.dart';
import 'add_reservation_page.dart';

class SessionsPage extends StatelessWidget {
  final bool isAdmin;
  final String? movieTitle;

  const SessionsPage({
    super.key,
    required this.isAdmin,
    this.movieTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Séances")),

      /// ➕ AJOUT (ADMIN)
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddSessionPage(),
                  ),
                );
              },
            )
          : null,

      body: BlocBuilder<SessionBloc, SessionState>(
        builder: (context, state) {
          if (state is SessionLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SessionLoaded) {
            List<SessionModel> sessions = state.sessions;

            if (movieTitle != null) {
              sessions =
                  sessions.where((s) => s.movieTitle == movieTitle).toList();
            }

            if (sessions.isEmpty) {
              return const Center(child: Text("Aucune séance disponible"));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];

                final date =
                    session.startTime.toLocal().toString().split(' ')[0];

                final time =
                    "${session.startTime.hour.toString().padLeft(2, '0')}:${session.startTime.minute.toString().padLeft(2, '0')}";

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(
                      Icons.schedule,
                      color: Colors.deepPurple,
                    ),
                    title: Text(
                      session.movieTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text("Salle : ${session.salle}"),
                        Text("Date : $date"),
                        Text("Heure : $time"),
                        Text("Prix : ${session.price} DH"),
                        Text(
                          "Places restantes : ${session.remainingSeats}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: session.remainingSeats > 0
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),

                    /// 👑 ADMIN / 👤 CLIENT
                    trailing: isAdmin
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          AddSessionPage(session: session),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  context
                                      .read<SessionBloc>()
                                      .add(DeleteSession(session.id));
                                },
                              ),
                            ],
                          )
                        : ElevatedButton(
                            onPressed: session.remainingSeats > 0
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AddReservationPage(
                                          session: session,
                                        ),
                                      ),
                                    );
                                  }
                                : null,
                            child: Text(
                              session.remainingSeats > 0
                                  ? "Réserver"
                                  : "Complet",
                            ),
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
