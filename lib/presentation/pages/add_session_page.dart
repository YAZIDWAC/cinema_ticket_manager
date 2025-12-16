import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/movie_model.dart';
import '../../domain/models/session_model.dart';

import '../blocs/movie/movie_bloc.dart';
import '../blocs/movie/movie_state.dart';

import '../blocs/salle/salle_bloc.dart';
import '../blocs/salle/salle_state.dart';

import '../blocs/session/session_bloc.dart';
import '../blocs/session/session_event.dart';
import '../blocs/session/session_state.dart';

class AddSessionPage extends StatefulWidget {
  final SessionModel? session;

  const AddSessionPage({
    super.key,
    this.session,
  });

  @override
  State<AddSessionPage> createState() => _AddSessionPageState();
}

class _AddSessionPageState extends State<AddSessionPage> {
  MovieModel? selectedMovie;
  String? selectedSalle;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final priceController = TextEditingController();

  /// 🔥 séances existantes
  List<SessionModel> existingSessions = [];

  @override
  void initState() {
    super.initState();

    if (widget.session != null) {
      final s = widget.session!;
      selectedSalle = s.salle;
      selectedDate = DateTime(
        s.startTime.year,
        s.startTime.month,
        s.startTime.day,
      );
      selectedTime = TimeOfDay(
        hour: s.startTime.hour,
        minute: s.startTime.minute,
      );
      priceController.text = s.price.toString();
    }
  }

  /// ❌ vérifie conflit horaire
  bool hasConflict(DateTime start, DateTime end) {
    return existingSessions.any((s) {
      if (widget.session != null && s.id == widget.session!.id) {
        return false; // ignore la séance en cours de modification
      }

      if (s.salle != selectedSalle) return false;

      return start.isBefore(s.endTime) && end.isAfter(s.startTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.session != null;

    return BlocListener<SessionBloc, SessionState>(
      listener: (context, state) {
        if (state is SessionLoaded) {
          existingSessions = state.sessions;
        }

        if (state is SessionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEdit ? "Modifier la séance" : "Ajouter une séance"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              /// 🎬 FILM
              BlocBuilder<MovieBloc, MovieState>(
                builder: (context, state) {
                  if (state is MovieLoaded) {
                    return DropdownButtonFormField<MovieModel>(
                      decoration: const InputDecoration(labelText: 'Film'),
                      value: selectedMovie,
                      items: state.movies
                          .map(
                            (m) => DropdownMenuItem<MovieModel>(
                              value: m,
                              child: Text(m.title),
                            ),
                          )
                          .toList(),
                      onChanged: (v) =>
                          setState(() => selectedMovie = v),
                    );
                  }
                  return const CircularProgressIndicator();
                },
              ),

              const SizedBox(height: 16),

              /// 🏢 SALLE
              BlocBuilder<SalleBloc, SalleState>(
                builder: (context, state) {
                  if (state is SalleLoaded) {
                    return DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Salle'),
                      value: selectedSalle,
                      items: state.salles
                          .map(
                            (s) => DropdownMenuItem<String>(
                              value: s.name,
                              child: Text(s.name),
                            ),
                          )
                          .toList(),
                      onChanged: (v) =>
                          setState(() => selectedSalle = v),
                    );
                  }
                  return const CircularProgressIndicator();
                },
              ),

              const SizedBox(height: 16),

              /// 📅 DATE
              ElevatedButton(
                child: Text(
                  selectedDate == null
                      ? "Choisir une date"
                      : selectedDate!
                          .toIso8601String()
                          .split('T')[0],
                ),
                onPressed: selectedSalle == null
                    ? null
                    : () async {
                        final d = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (d != null) {
                          setState(() {
                            selectedDate = d;
                            selectedTime = null;
                          });
                        }
                      },
              ),

              /// ⏰ HEURE
              ElevatedButton(
                child: Text(
                  selectedTime == null
                      ? "Choisir une heure"
                      : selectedTime!.format(context),
                ),
                onPressed: selectedDate == null || selectedMovie == null
                    ? null
                    : () async {
                        final t = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (t == null) return;

                        final start = DateTime(
                          selectedDate!.year,
                          selectedDate!.month,
                          selectedDate!.day,
                          t.hour,
                          t.minute,
                        );

                        final end = start.add(
                          Duration(minutes: selectedMovie!.duration),
                        );

                        if (hasConflict(start, end)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "⛔ Salle occupée à cette date et heure",
                              ),
                            ),
                          );
                          return;
                        }

                        setState(() => selectedTime = t);
                      },
              ),

              const SizedBox(height: 16),

              /// 💰 PRIX
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Prix"),
              ),

              const SizedBox(height: 24),

              /// 💾 ENREGISTRER
              ElevatedButton(
                child: Text(isEdit ? "Modifier" : "Enregistrer"),
                onPressed: () {
                  if (selectedMovie == null ||
                      selectedSalle == null ||
                      selectedDate == null ||
                      selectedTime == null ||
                      priceController.text.isEmpty) return;

                  final startTime = DateTime(
                    selectedDate!.year,
                    selectedDate!.month,
                    selectedDate!.day,
                    selectedTime!.hour,
                    selectedTime!.minute,
                  );

                  final endTime = startTime.add(
                    Duration(minutes: selectedMovie!.duration),
                  );

                  if (hasConflict(startTime, endTime)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "⛔ Conflit détecté avec une autre séance",
                        ),
                      ),
                    );
                    return;
                  }

                  final session = SessionModel(
                    id: widget.session?.id ?? '',
                    movieTitle: selectedMovie!.title,
                    salle: selectedSalle!,
                    startTime: startTime,
                    endTime: endTime,
                    price: int.parse(priceController.text),
                  );

                  context.read<SessionBloc>().add(
                        isEdit
                            ? UpdateSession(session: session)
                            : AddSession(session: session),
                      );

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
