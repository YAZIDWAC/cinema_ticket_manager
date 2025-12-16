import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/salle_repository.dart';
import 'salle_event.dart';
import 'salle_state.dart';

class SalleBloc extends Bloc<SalleEvent, SalleState> {
  final SalleRepository repository;

  SalleBloc(this.repository) : super(SalleInitial()) {
    on<LoadSalles>((event, emit) async {
      emit(SalleLoading());
      await emit.forEach(
        repository.getSalles(),
        onData: (salles) => SalleLoaded(salles),
        onError: (_, __) => SalleError('Erreur chargement salles'),
      );
    });

    on<AddSalle>((event, emit) async {
      await repository.addSalle(event.salle);
    });

    on<UpdateSalle>((event, emit) async {
      await repository.updateSalle(event.salle);
    });

    on<DeleteSalle>((event, emit) async {
  await repository.deleteSalle(event.salleId);
});

  }
}
