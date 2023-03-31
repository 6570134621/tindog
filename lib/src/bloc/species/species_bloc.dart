import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'species_event.dart';
part 'species_state.dart';

class SpeciesBloc extends Bloc<SpeciesEvent, SpeciesState> {
  SpeciesBloc() : super(SpeciesState(species: 'All')) {
    on<SpeciesSelected>((event, emit) {
     emit(state.ChangeSpecies(species: event.species));
    });
  }
}
