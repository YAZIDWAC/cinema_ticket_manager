import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../domain/models/reservation_model.dart';

class TicketDetailsPage extends StatelessWidget {
  final ReservationModel reservation;

  const TicketDetailsPage({
    Key? key,
    required this.reservation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Détails du ticket")),
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
            const SizedBox(height: 8),
            Text("Salle : ${reservation.salle}"),
            Text("Date : ${reservation.date}"),
            Text("Heure : ${reservation.time}"),
            Text("Tickets : ${reservation.tickets}"),
            Text(
              "Total payé : ${reservation.total} DH",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "QR Code",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
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
