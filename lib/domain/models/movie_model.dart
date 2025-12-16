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
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Movie data is null');
    }

    return MovieModel(
      id: doc.id,
      title: data['title']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      duration: data['duration']?.toString() ?? '',
      hasVF: data['hasVF'] == true,
      hasVO: data['hasVO'] == true,
      hasVOSTFR: data['hasVOSTFR'] == true,
      imageUrl: data['imageUrl']?.toString() ?? '',
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
