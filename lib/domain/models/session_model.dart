import 'package:cloud_firestore/cloud_firestore.dart';

class SessionModel {
  final String id;
  final String movieTitle;
  final String salle;
  final DateTime startTime;
  final DateTime endTime;
  final int price;

  SessionModel({
    required this.id,
    required this.movieTitle,
    required this.salle,
    required this.startTime,
    required this.endTime,
    required this.price,
  });

  factory SessionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final Timestamp? startTs = data['startTime'];
    final Timestamp? endTs = data['endTime'];

    return SessionModel(
      id: doc.id,
      movieTitle: data['movieTitle'] ?? '',
      salle: data['salle'] ?? '',
      startTime: startTs?.toDate() ?? DateTime.now(),
      endTime: endTs?.toDate() ??
          DateTime.now().add(const Duration(minutes: 90)),
      price: (data['price'] is int)
          ? data['price']
          : int.tryParse(data['price'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'movieTitle': movieTitle,
      'salle': salle,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'price': price,
    };
  }
}
