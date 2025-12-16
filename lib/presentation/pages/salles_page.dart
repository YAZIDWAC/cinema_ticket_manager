import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/salle_model.dart';
import '../blocs/salle/salle_bloc.dart';
import '../blocs/salle/salle_event.dart';
import '../blocs/salle/salle_state.dart';
import 'add_salle_page.dart';

class SallesPage extends StatelessWidget {
  const SallesPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<SalleBloc>().add(LoadSalles());

    return Scaffold(
      appBar: AppBar(title: const Text('Gestion des salles')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddSallePage()),
          );
        },
      ),
      body: BlocBuilder<SalleBloc, SalleState>(
        builder: (context, state) {
          if (state is SalleLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SalleLoaded) {
            if (state.salles.isEmpty) {
              return const Center(child: Text('Aucune salle'));
            }

            return ListView.builder(
              itemCount: state.salles.length,
              itemBuilder: (context, index) {
                final salle = state.salles[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(
                      salle.name.isEmpty ? 'Salle sans nom' : salle.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Capacité: ${salle.capacity} | '
                      '3D: ${salle.is3D ? "oui" : "non"} | '
                      'IMAX: ${salle.isIMAX ? "oui" : "non"}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ✏️ MODIFIER
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddSallePage(salle: salle),
                              ),
                            );
                          },
                        ),

                        // 🗑️ SUPPRIMER
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Supprimer la salle'),
                                content: const Text(
                                    'Voulez-vous vraiment supprimer cette salle ?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context),
                                    child: const Text('Annuler'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      context
                                          .read<SalleBloc>()
                                          .add(DeleteSalle(salle.id));
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Supprimer',
                                      style:
                                          TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          if (state is SalleError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
