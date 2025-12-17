import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../blocs/reservation/reservation_bloc.dart';
import '../blocs/reservation/reservation_event.dart';
import '../blocs/reservation/reservation_state.dart';
import '../../domain/models/reservation_model.dart';
import 'ticket_details_page.dart';

class MyTicketsPage extends StatefulWidget {
  const MyTicketsPage({super.key});

  @override
  State<MyTicketsPage> createState() => _MyTicketsPageState();
}

class _MyTicketsPageState extends State<MyTicketsPage> {
  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser!;
    context
        .read<ReservationBloc>()
        .add(LoadMyReservations(user.uid));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes tickets"),
        centerTitle: true,
      ),
      body: BlocBuilder<ReservationBloc, ReservationState>(
        builder: (context, state) {
          if (state is ReservationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ReservationError) {
            return Center(child: Text(state.message));
          }

          if (state is ReservationLoaded) {
            if (state.reservations.isEmpty) {
              return const Center(
                child: Text(
                  "Aucun ticket trouvé",
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              itemCount: state.reservations.length,
              itemBuilder: (context, index) {
                final ReservationModel r =
                    state.reservations[index];

                final date =
                    r.startTime.toLocal().toString().split(' ')[0];
                final time =
                    "${r.startTime.hour.toString().padLeft(2, '0')}:${r.startTime.minute.toString().padLeft(2, '0')}";

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            TicketDetailsPage(reservation: r),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 6,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          /// 🎬 INFOS
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r.movieTitle,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text("$date • $time"),
                                Text("Salle : ${r.salle}"),
                                Text("Tickets : ${r.tickets}"),
                                const SizedBox(height: 4),
                                Text(
                                  "${r.total} DH",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// 🔳 QR CODE MINI
                          QrImageView(
                            data: r.qrCode,
                            size: 70,
                            backgroundColor: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
