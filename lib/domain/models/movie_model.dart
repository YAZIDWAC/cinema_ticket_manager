import 'package:cloud_firestore/cloud_firestore.dart';

class MovieModel {
  final String id;
  final String title;
  final String description;
  final int duration; // ⬅️ durée en minutes (INT)
  final bool hasVF;
  final bool hasVO;
  final bool hasVOSTFR;
  final String imageUrl;

  MovieModel({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.hasVF,
    required this.hasVO,
    required this.hasVOSTFR,
    required this.imageUrl,
  });

  /// 🔥 CONVERSION FIRESTORE → APP (ULTRA SÉCURISÉE)
  factory MovieModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // 🛡️ Protection contre int / String / null
    final rawDuration = data['duration'];
    int duration;

    if (rawDuration is int) {
      duration = rawDuration;
    } else if (rawDuration is String) {
      duration = int.tryParse(rawDuration) ?? 0;
    } else {
      duration = 0;
    }

    return MovieModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      duration: duration,
      hasVF: data['hasVF'] == true,
      hasVO: data['hasVO'] == true,
      hasVOSTFR: data['hasVOSTFR'] == true,
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  /// 🔥 CONVERSION APP → FIRESTORE
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'duration': duration, // ⬅️ TOUJOURS INT
      'hasVF': hasVF,
      'hasVO': hasVO,
      'hasVOSTFR': hasVOSTFR,
      'imageUrl': imageUrl,
    };
  }
}
