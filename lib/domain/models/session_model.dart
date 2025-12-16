import 'package:cloud_firestore/cloud_firestore.dart';

class SessionModel {
  final String id;
  final String movieTitle;
  final String salle;
  final String date;
  final String time;
  final int price;

  SessionModel({
    required this.id,
    required this.movieTitle,
    required this.salle,
    required this.date,
    required this.time,
    required this.price,
  });

  factory SessionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return SessionModel(
      id: doc.id,
      movieTitle: data['movieTitle'] ?? '',
      salle: data['salle'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      price: (data['price'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'movieTitle': movieTitle,
      'salle': salle,
      'date': date,
      'time': time,
      'price': price,
    };
  }
}
