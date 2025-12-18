import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/session_model.dart';
import '../../domain/models/reservation_model.dart';

import '../blocs/reservation/reservation_bloc.dart';
import '../blocs/reservation/reservation_event.dart';
import '../blocs/session/session_bloc.dart';
import '../blocs/session/session_event.dart';

const Color kGrenat = Color(0xFF8B1E3F);

class AddReservationPage extends StatefulWidget {
  final SessionModel session;

  const AddReservationPage({
    super.key,
    required this.session,
  });

  @override
  State<AddReservationPage> createState() => _AddReservationPageState();
}

class _AddReservationPageState extends State<AddReservationPage> {
  int tickets = 1;
  bool isPaying = false;

  /// 🔥 PLACES RESTANTES LOCALES (IMPORTANT)
  late int remainingSeats;

  @override
  void initState() {
    super.initState();
    remainingSeats = widget.session.remainingSeats;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final total = tickets * widget.session.price;

    final isPastSession =
        widget.session.startTime.isBefore(DateTime.now());
    final noSeatsLeft = remainingSeats <= 0;

    final date =
        widget.session.startTime.toLocal().toString().split(' ')[0];
    final time =
        "${widget.session.startTime.hour.toString().padLeft(2, '0')}:${widget.session.startTime.minute.toString().padLeft(2, '0')}";

    return Scaffold(
      appBar: AppBar(title: const Text("Réservation")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🎟️ INFOS SÉANCE
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.session.movieTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text("Salle : ${widget.session.salle}"),
                  Text("Date : $date"),
                  Text("Heure : $time"),
                  Text("Prix : ${widget.session.price} DH"),
                  const SizedBox(height: 8),
                  Text(
                    "Places restantes : $remainingSeats",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kGrenat,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// 🎫 NOMBRE DE TICKETS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Nombre de tickets",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: tickets > 1
                          ? () => setState(() => tickets--)
                          : null,
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text(
                      tickets.toString(),
                      style: const TextStyle(fontSize: 18),
                    ),
                    IconButton(
                      onPressed: tickets < remainingSeats
                          ? () => setState(() => tickets++)
                          : null,
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// 💰 TOTAL
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: kGrenat.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "$total DH",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kGrenat,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            /// 💳 BOUTON PAYER
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGrenat,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: user == null || isPastSession || noSeatsLeft
                    ? null
                    : () async {
                        setState(() => isPaying = true);

                        await Future.delayed(
                          const Duration(seconds: 1),
                        );

                        final reservation = ReservationModel(
                          id: '',
                          userId: user.uid,
                          sessionId: widget.session.id,
                          movieTitle: widget.session.movieTitle,
                          salle: widget.session.salle,
                          startTime: widget.session.startTime,
                          endTime: widget.session.endTime,
                          tickets: tickets,
                          price: widget.session.price,
                          total: total,
                          qrCode:
                              '${user.uid}-${DateTime.now().millisecondsSinceEpoch}',
                        );

                        /// 🔥 AJOUT RÉSERVATION
                        context
                            .read<ReservationBloc>()
                            .add(AddReservation(reservation));

                        /// 🔥 RECHARGER LES SESSIONS
                        context
                            .read<SessionBloc>()
                            .add(LoadSessions());

                        if (!mounted) return;

                        /// ✅ DIMINUTION IMMÉDIATE À L'ÉCRAN
                        setState(() {
                          remainingSeats -= tickets;
                          isPaying = false;
                        });

                        Navigator.pop(context);
                      },
                child: isPaying
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Payer",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
