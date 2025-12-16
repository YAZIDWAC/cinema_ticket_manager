import '../../../domain/models/salle_model.dart';

abstract class SalleState {}

class SalleInitial extends SalleState {}

class SalleLoading extends SalleState {}

class SalleLoaded extends SalleState {
  final List<SalleModel> salles;
  SalleLoaded(this.salles);
}

class SalleError extends SalleState {
  final String message;
  SalleError(this.message);
}
