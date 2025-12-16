import '../../../domain/models/salle_model.dart';

abstract class SalleEvent {}

class LoadSalles extends SalleEvent {}

class AddSalle extends SalleEvent {
  final SalleModel salle;
  AddSalle(this.salle);
}

class UpdateSalle extends SalleEvent {
  final SalleModel salle;
  UpdateSalle(this.salle);
}

class DeleteSalle extends SalleEvent {
  final String salleId;
  DeleteSalle(this.salleId);
}
