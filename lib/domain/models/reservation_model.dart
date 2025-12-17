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
  });

  /// 🔁 FIRESTORE → APP
  factory ReservationModel.fromJson(
    Map<String, dynamic> json,
    String id,
  ) {
    return ReservationModel(
      id: id,
      userId: json['userId'],
      sessionId: json['sessionId'],
      movieTitle: json['movieTitle'],
      salle: json['salle'],
      startTime:
          (json['startTime'] as Timestamp).toDate(),
      endTime:
          (json['endTime'] as Timestamp).toDate(),
      tickets: json['tickets'],
      price: json['price'],
      total: json['total'],
      qrCode: json['qrCode'],
    );
  }

  /// 🔁 APP → FIRESTORE
  Map<String, dynamic> toJson() {
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
    };
  }
}
