class ReservationModel {
  final String id;
  final String userId;
  final String sessionId;
  final int seats;
  final DateTime createdAt;

  ReservationModel({
    required this.id,
    required this.userId,
    required this.sessionId,
    required this.seats,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'sessionId': sessionId,
      'seats': seats,
      'createdAt': createdAt,
    };
  }

  factory ReservationModel.fromMap(String id, Map<String, dynamic> map) {
    return ReservationModel(
      id: id,
      userId: map['userId'],
      sessionId: map['sessionId'],
      seats: map['seats'],
      createdAt: map['createdAt'].toDate(),
    );
  }
}
