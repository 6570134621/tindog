part of 'species_bloc.dart';


abstract class SpeciesEvent extends Equatable{
  final String species;
  const SpeciesEvent(this.species);
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
class SpeciesSelected extends SpeciesEvent {
  SpeciesSelected(super.species);
}
