import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/session_model.dart';
import '../blocs/session/session_bloc.dart';
import '../blocs/session/session_event.dart';

class AddSessionPage extends StatefulWidget {
  final SessionModel? session;
  const AddSessionPage({super.key, this.session});

  @override
  State<AddSessionPage> createState() => _AddSessionPageState();
}

class _AddSessionPageState extends State<AddSessionPage> {
  final movieController = TextEditingController();
  final salleController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final priceController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.session != null) {
      movieController.text = widget.session!.movieTitle;
      salleController.text = widget.session!.salle;
      dateController.text = widget.session!.date;
      timeController.text = widget.session!.time;
      priceController.text = widget.session!.price.toString();
    }
  }

  void _save() {
    final session = SessionModel(
      id: widget.session?.id ?? '',
      movieTitle: movieController.text,
      salle: salleController.text,
      date: dateController.text,
      time: timeController.text,
      price: int.parse(priceController.text),
    );

    if (widget.session == null) {
      context.read<SessionBloc>().add(AddSession(session));
    } else {
      context
          .read<SessionBloc>()
          .add(UpdateSession(widget.session!.id, session));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.session == null
            ? 'Ajouter une séance'
            : 'Modifier la séance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: movieController,
              decoration: const InputDecoration(labelText: 'Film'),
            ),
            TextField(
              controller: salleController,
              decoration: const InputDecoration(labelText: 'Salle'),
            ),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(labelText: 'Date'),
            ),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(labelText: 'Heure'),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Prix'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _save,
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}
