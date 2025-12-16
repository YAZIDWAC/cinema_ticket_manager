import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/salle_model.dart';
import '../blocs/salle/salle_bloc.dart';
import '../blocs/salle/salle_event.dart';

class AddSallePage extends StatefulWidget {
  final SalleModel? salle;

  const AddSallePage({super.key, this.salle});

  @override
  State<AddSallePage> createState() => _AddSallePageState();
}

class _AddSallePageState extends State<AddSallePage> {
  final nameCtrl = TextEditingController();
  final capacityCtrl = TextEditingController();

  bool is3D = false;
  bool isIMAX = false;

  @override
  void initState() {
    super.initState();
    if (widget.salle != null) {
      nameCtrl.text = widget.salle!.name;
      capacityCtrl.text = widget.salle!.capacity.toString();
      is3D = widget.salle!.is3D;
      isIMAX = widget.salle!.isIMAX;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.salle == null
            ? 'Ajouter une salle'
            : 'Modifier la salle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Nom de la salle'),
            ),
            TextField(
              controller: capacityCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Capacité'),
            ),
            const SizedBox(height: 16),

            SwitchListTile(
              title: const Text('Salle 3D'),
              value: is3D,
              onChanged: (v) => setState(() => is3D = v),
            ),
            SwitchListTile(
              title: const Text('Salle IMAX'),
              value: isIMAX,
              onChanged: (v) => setState(() => isIMAX = v),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Enregistrer'),
              onPressed: () {
                final salle = SalleModel(
                  id: widget.salle?.id ?? '',
                  name: nameCtrl.text,
                  capacity: int.tryParse(capacityCtrl.text) ?? 0,
                  is3D: is3D,
                  isIMAX: isIMAX,
                );

                if (widget.salle == null) {
                  context.read<SalleBloc>().add(AddSalle(salle));
                } else {
                  context.read<SalleBloc>().add(UpdateSalle(salle));
                }

                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
