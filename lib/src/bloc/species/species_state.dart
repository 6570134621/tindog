part of 'species_bloc.dart';

class SpeciesState extends Equatable {
  final String species;

  const SpeciesState({required this.species});

  SpeciesState ChangeSpecies({String? species}) {
    return SpeciesState(species: species ?? this.species);
  }

  List<Object> get props => [species];
}
