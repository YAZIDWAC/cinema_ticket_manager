import 'package:cloud_firestore/cloud_firestore.dart';

class SessionModel {
  final String id;
  final String movieTitle;
  final String salle;
  final DateTime startTime;
  final DateTime endTime;
  final int price;
  final int totalSeats;
  final int reservedSeats;

  SessionModel({
    required this.id,
    required this.movieTitle,
    required this.salle,
    required this.startTime,
    required this.endTime,
    required this.price,
    required this.totalSeats,
    required this.reservedSeats,
  });

  int get availableSeats => totalSeats - reservedSeats;

  factory SessionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return SessionModel(
      id: doc.id,
      movieTitle: data['movieTitle'],
      salle: data['salle'],
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      price: data['price'],
      totalSeats: data['totalSeats'] ?? 0,
      reservedSeats: data['reservedSeats'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'movieTitle': movieTitle,
      'salle': salle,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'price': price,
      'totalSeats': totalSeats,
      'reservedSeats': reservedSeats,
    };
    
  }
  int get remainingSeats => totalSeats - reservedSeats;

}
