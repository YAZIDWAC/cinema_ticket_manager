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
      appBar: AppBar(
        title: const Text("Séances"),
      ),

      /// ➕ AJOUT SÉANCE (ADMIN SEULEMENT)
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

            /// 🎬 FILTRAGE PAR FILM (CLIENT)
            if (movieTitle != null) {
              sessions = sessions
                  .where((s) => s.movieTitle == movieTitle)
                  .toList();
            }

            if (sessions.isEmpty) {
              return const Center(
                child: Text("Aucune séance disponible"),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];

                final date =
                    session.startTime.toLocal().toString().split(' ')[0];

                final time =
                    "${session.startTime.hour.toString().padLeft(2, '0')}:"
                    "${session.startTime.minute.toString().padLeft(2, '0')}";

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      session.movieTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Salle : ${session.salle}"),
                          Text("Date : $date"),
                          Text("Heure : $time"),
                          Text("Prix : ${session.price} DH"),
                        ],
                      ),
                    ),

                    /// 👑 ADMIN / 👤 CLIENT
                    trailing: isAdmin
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              /// ✏️ MODIFIER
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AddSessionPage(
                                        session: session,
                                      ),
                                    ),
                                  );
                                },
                              ),

                              /// 🗑 SUPPRIMER
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
