import 'dart:async';

import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:coffee_app/coffee/domain/use_case/load_coffee_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

part 'coffee_event.dart';
part 'coffee_state.dart';

/// Bloc for managing the state of coffee.
/// It handles loading coffee data and refreshing the list of favorite coffees.
@injectable
class CoffeeBloc extends Bloc<CoffeeEvent, CoffeeState> {
  CoffeeBloc(this._loadCoffeeUseCase) : super(CoffeeState.initial()) {
    on<LoadCoffeeEvent>(_onLoadCoffeeEvent);
  }

  final LoadCoffeeUseCase _loadCoffeeUseCase;

  Future<void> _onLoadCoffeeEvent(
    LoadCoffeeEvent event,
    Emitter<CoffeeState> emit,
  ) async {
    emit(state.copyWith(status: CoffeeStatus.loading));
    final failureOrCoffee = await _loadCoffeeUseCase.execute();

    failureOrCoffee.fold(
      (failure) => emit(
        state.copyWith(
          status: CoffeeStatus.error,
          coffee: Coffee.empty(),
        ),
      ),
      (coffee) {
        emit(
          state.copyWith(
            status: CoffeeStatus.loaded,
            coffee: coffee,
          ),
        );
      },
    );
  }
}
