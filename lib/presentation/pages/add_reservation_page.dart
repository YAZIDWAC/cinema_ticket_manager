import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/session_model.dart';
import '../../domain/models/reservation_model.dart';
import '../blocs/reservation/reservation_bloc.dart';
import '../blocs/reservation/reservation_event.dart';

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

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final total = tickets * widget.session.price;

    final isPastSession =
        widget.session.startTime.isBefore(DateTime.now());

    final noSeatsLeft = widget.session.remainingSeats <= 0;

    final date =
        widget.session.startTime.toLocal().toString().split(' ')[0];

    final time =
        "${widget.session.startTime.hour.toString().padLeft(2, '0')}:${widget.session.startTime.minute.toString().padLeft(2, '0')}";

    return Scaffold(
      appBar: AppBar(title: const Text("Réservation")),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
            const SizedBox(height: 8),
            Text("Salle : ${widget.session.salle}"),
            Text("Date : $date"),
            Text("Heure : $time"),
            Text("Prix : ${widget.session.price} DH"),

            const Divider(height: 32),

            const Text(
              "Nombre de tickets",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed:
                      tickets > 1 ? () => setState(() => tickets--) : null,
                ),
                Text(
                  tickets.toString(),
                  style: const TextStyle(fontSize: 18),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: tickets < widget.session.remainingSeats
                      ? () => setState(() => tickets++)
                      : null,
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              "Total : $total DH",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Spacer(),

            /// 💳 PAIEMENT
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isPaying
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: user == null ||
                                isPastSession ||
                                noSeatsLeft
                            ? null
                            : () async {
                                setState(() => isPaying = true);

                                await Future.delayed(
                                  const Duration(seconds: 2),
                                );

                                final reservation = ReservationModel(
                                  id: '',
                                  userId: user.uid,
                                  sessionId: widget.session.id,
                                  movieTitle:
                                      widget.session.movieTitle,
                                  salle: widget.session.salle,
                                  startTime:
                                      widget.session.startTime,
                                  endTime: widget.session.endTime,
                                  tickets: tickets,
                                  price: widget.session.price,
                                  total: total,
                                  qrCode:
                                      '${user.uid}-${DateTime.now().millisecondsSinceEpoch}',
                                );

                                context
                                    .read<ReservationBloc>()
                                    .add(AddReservation(reservation));

                                if (!mounted) return;

                                setState(() => isPaying = false);

                                Navigator.pop(context);
                              },
                        child: Text(
                          isPastSession
                              ? "Séance passée"
                              : noSeatsLeft
                                  ? "Complet"
                                  : "Payer",
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
