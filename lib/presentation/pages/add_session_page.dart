import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/movie/movie_bloc.dart';
import '../blocs/movie/movie_event.dart';
import '../blocs/movie/movie_state.dart';

import '../blocs/salle/salle_bloc.dart';
import '../blocs/salle/salle_event.dart';
import '../blocs/salle/salle_state.dart';

import '../blocs/session/session_bloc.dart';
import '../blocs/session/session_event.dart';


class AddSessionPage extends StatefulWidget {
  const AddSessionPage({super.key});

  @override
  State<AddSessionPage> createState() => _AddSessionPageState();
}

class _AddSessionPageState extends State<AddSessionPage> {
  String? selectedMovie;
  String? selectedSalle;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<MovieBloc>().add(LoadMovies());
    context.read<SalleBloc>().add(LoadSalles());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter une séance')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            /// FILM
            BlocBuilder<MovieBloc, MovieState>(
              builder: (context, state) {
                if (state is MovieLoaded) {
                  return DropdownButtonFormField<String>(
                    value: selectedMovie,
                    decoration: const InputDecoration(labelText: 'Film'),
                    items: state.movies
                        .map(
                          (m) => DropdownMenuItem(
                            value: m.title,
                            child: Text(m.title),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => selectedMovie = v),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),

            const SizedBox(height: 16),

            /// SALLE
            BlocBuilder<SalleBloc, SalleState>(
              builder: (context, state) {
                if (state is SalleLoaded) {
                  return DropdownButtonFormField<String>(
                    value: selectedSalle,
                    decoration: const InputDecoration(labelText: 'Salle'),
                    items: state.salles
                        .map(
                          (s) => DropdownMenuItem(
                            value: s.name,
                            child: Text(s.name),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => selectedSalle = v),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),

            const SizedBox(height: 16),

            /// DATE
            TextFormField(
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Date'),
              controller: TextEditingController(
                text: selectedDate == null
                    ? ''
                    : '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}',
              ),
              onTap: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (d != null) setState(() => selectedDate = d);
              },
            ),

            const SizedBox(height: 16),

            /// HEURE
            TextFormField(
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Heure'),
              controller: TextEditingController(
                text: selectedTime?.format(context) ?? '',
              ),
              onTap: () async {
                final t = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (t != null) setState(() => selectedTime = t);
              },
            ),

            const SizedBox(height: 16),

            /// PRIX
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Prix (DA)'),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                if (selectedMovie == null ||
                    selectedSalle == null ||
                    selectedDate == null ||
                    selectedTime == null ||
                    priceController.text.isEmpty) return;

                context.read<SessionBloc>().add(
                      AddSession(
                        movieTitle: selectedMovie!,
                        salle: selectedSalle!,
                        date:
                            '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}',
                        time: selectedTime!.format(context),
                        price: int.parse(priceController.text),
                      ),
                    );

                Navigator.pop(context);
              },
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}
