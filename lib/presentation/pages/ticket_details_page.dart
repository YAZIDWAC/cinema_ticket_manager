import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../domain/models/reservation_model.dart';

class TicketDetailsPage extends StatelessWidget {
  final ReservationModel reservation;

  const TicketDetailsPage({
    super.key,
    required this.reservation,
  });

  @override
  Widget build(BuildContext context) {
    final date =
        reservation.startTime.toLocal().toString().split(' ')[0];

    final time =
        "${reservation.startTime.hour.toString().padLeft(2, '0')}:"
        "${reservation.startTime.minute.toString().padLeft(2, '0')}";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails du ticket"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              reservation.movieTitle,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text("Salle : ${reservation.salle}"),
            Text("Date : $date"),
            Text("Heure : $time"),
            Text("Tickets : ${reservation.tickets}"),

            const SizedBox(height: 8),

            Text(
              "Total payé : ${reservation.total} DH",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              "QR Code",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 16),

            QrImageView(
              data: reservation.qrCode,
              size: 220,
            ),
          ],
        ),
      ),
    );
  }
}
