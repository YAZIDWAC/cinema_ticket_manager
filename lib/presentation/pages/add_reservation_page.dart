import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

    final date =
        widget.session.startTime.toLocal().toString().split(' ')[0];

    final time =
        "${widget.session.startTime.hour.toString().padLeft(2, '0')}:"
        "${widget.session.startTime.minute.toString().padLeft(2, '0')}";

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
            Text("Prix unitaire : ${widget.session.price} DH"),

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
                  onPressed: () => setState(() => tickets++),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              "Total à payer : $total DH",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: isPaying
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Payer (simulation)"),
                onPressed: user == null || isPaying
                    ? null
                    : () async {
                        setState(() => isPaying = true);

                        await Future.delayed(const Duration(seconds: 2));

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
                          createdAt: Timestamp.now(),
                        );

                        context
                            .read<ReservationBloc>()
                            .add(AddReservation(reservation));

                        if (!mounted) return;

                        setState(() => isPaying = false);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Paiement effectué et réservation créée ✅",
                            ),
                          ),
                        );

                        Navigator.pop(context);
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
