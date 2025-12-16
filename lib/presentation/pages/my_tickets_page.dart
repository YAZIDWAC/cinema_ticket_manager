import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../blocs/reservation/reservation_bloc.dart';
import '../blocs/reservation/reservation_event.dart';
import '../blocs/reservation/reservation_state.dart';
import '../../domain/models/reservation_model.dart';
import 'ticket_details_page.dart';

class MyTicketsPage extends StatelessWidget {
  const MyTicketsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    // Charger les réservations du user
    context.read<ReservationBloc>().add(
          LoadMyReservations(user.uid),
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes tickets"),
      ),
      body: BlocBuilder<ReservationBloc, ReservationState>(
        builder: (context, state) {
          if (state is ReservationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ReservationLoaded) {
            if (state.reservations.isEmpty) {
              return const Center(
                child: Text("Aucun ticket trouvé"),
              );
            }

            return ListView.builder(
              itemCount: state.reservations.length,
              itemBuilder: (context, index) {
                final ReservationModel r = state.reservations[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(
                      r.movieTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${r.date} • ${r.time}\nSalle : ${r.salle}",
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${r.total} DH",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const Text(
                          "Voir",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              TicketDetailsPage(reservation: r),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }

          if (state is ReservationError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
