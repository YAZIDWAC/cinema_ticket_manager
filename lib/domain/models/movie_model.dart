import 'package:cloud_firestore/cloud_firestore.dart';

class MovieModel {
  final String id;
  final String title;
  final String description;
  final String duration;
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

  factory MovieModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MovieModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      duration: data['duration'] ?? '',
      hasVF: data['hasVF'] ?? false,
      hasVO: data['hasVO'] ?? false,
      hasVOSTFR: data['hasVOSTFR'] ?? false,
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'duration': duration,
      'hasVF': hasVF,
      'hasVO': hasVO,
      'hasVOSTFR': hasVOSTFR,
      'imageUrl': imageUrl,
    };
  }
}
