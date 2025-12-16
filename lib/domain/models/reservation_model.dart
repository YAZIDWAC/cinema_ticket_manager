import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationModel {
  final String id;
  final String userId;
  final String sessionId;
  final String movieTitle;
  final String salle;
  final DateTime startTime;
  final DateTime endTime;
  final int tickets;
  final int price;
  final int total;
  final String qrCode;
  final DateTime? createdAt; // ✅ nullable côté app

  ReservationModel({
    required this.id,
    required this.userId,
    required this.sessionId,
    required this.movieTitle,
    required this.salle,
    required this.startTime,
    required this.endTime,
    required this.tickets,
    required this.price,
    required this.total,
    required this.qrCode,
    this.createdAt,
  });

  factory ReservationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ReservationModel(
      id: doc.id,
      userId: data['userId'],
      sessionId: data['sessionId'],
      movieTitle: data['movieTitle'],
      salle: data['salle'],
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      tickets: data['tickets'],
      price: data['price'],
      total: data['total'],
      qrCode: data['qrCode'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'sessionId': sessionId,
      'movieTitle': movieTitle,
      'salle': salle,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'tickets': tickets,
      'price': price,
      'total': total,
      'qrCode': qrCode,
      'createdAt': FieldValue.serverTimestamp(), // ✅ correct
    };
  }
}
