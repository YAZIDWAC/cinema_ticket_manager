import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/models/movie_model.dart';
import '../blocs/movie/movie_bloc.dart';
import '../blocs/movie/movie_event.dart';
import '../../data/services/cloudinary_service.dart';

class AddMoviePage extends StatefulWidget {
  final MovieModel? movie;

  const AddMoviePage({super.key, this.movie});

  @override
  State<AddMoviePage> createState() => _AddMoviePageState();
}

class _AddMoviePageState extends State<AddMoviePage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final durationController = TextEditingController();

  bool hasVF = false;
  bool hasVO = false;
  bool hasVOSTFR = false;

  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    if (widget.movie != null) {
      titleController.text = widget.movie!.title;
      descriptionController.text = widget.movie!.description;
      durationController.text = widget.movie!.duration;
      hasVF = widget.movie!.hasVF;
      hasVO = widget.movie!.hasVO;
      hasVOSTFR = widget.movie!.hasVOSTFR;
    }
  }

  Future<void> pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => selectedImage = File(image.path));
    }
  }

  Future<void> submitMovie() async {
    String imageUrl = widget.movie?.imageUrl ?? '';

    if (selectedImage != null) {
      imageUrl =
          await CloudinaryService.uploadImage(selectedImage!) ?? imageUrl;
    }

    final movie = MovieModel(
      id: widget.movie?.id ?? '',
      title: titleController.text,
      description: descriptionController.text,
      duration: durationController.text,
      hasVF: hasVF,
      hasVO: hasVO,
      hasVOSTFR: hasVOSTFR,
      imageUrl: imageUrl,
    );

    if (widget.movie == null) {
      context.read<MovieBloc>().add(AddMovie(movie));
    } else {
      context.read<MovieBloc>().add(UpdateMovie(movie));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie == null
            ? 'Ajouter un film'
            : 'Modifier le film'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Titre'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: durationController,
              decoration: const InputDecoration(labelText: 'Durée'),
            ),

            CheckboxListTile(
              title: const Text('VF'),
              value: hasVF,
              onChanged: (v) => setState(() => hasVF = v!),
            ),
            CheckboxListTile(
              title: const Text('VO'),
              value: hasVO,
              onChanged: (v) => setState(() => hasVO = v!),
            ),
            CheckboxListTile(
              title: const Text('VOSTFR'),
              value: hasVOSTFR,
              onChanged: (v) => setState(() => hasVOSTFR = v!),
            ),

            ElevatedButton(
              onPressed: pickImage,
              child: const Text('Choisir une image'),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: submitMovie,
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}
