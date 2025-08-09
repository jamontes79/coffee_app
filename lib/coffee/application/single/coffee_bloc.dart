import 'dart:async';

import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:coffee_app/coffee/domain/use_case/load_coffee_use_case.dart';
import 'package:coffee_app/coffee/domain/use_case/load_favorite_coffees_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

part 'coffee_event.dart';
part 'coffee_state.dart';

@injectable
class CoffeeBloc extends Bloc<CoffeeEvent, CoffeeState> {
  CoffeeBloc(this._loadCoffeeUseCase, this._loadFavoriteCoffeesUseCase)
    : super(CoffeeState.initial()) {
    on<LoadCoffeeEvent>(_onLoadCoffeeEvent);
    on<RefreshFavouriteCoffeeEvent>(_onRefreshFavouriteCoffeeEvent);
  }

  final LoadCoffeeUseCase _loadCoffeeUseCase;
  final LoadFavoriteCoffeesUseCase _loadFavoriteCoffeesUseCase;

  Future<void> _onLoadCoffeeEvent(
    LoadCoffeeEvent event,
    Emitter<CoffeeState> emit,
  ) async {
    emit(state.copyWith(status: CoffeeStatus.loading));
    final failureOrCoffee = await _loadCoffeeUseCase.execute();
    final failureOrFavourites = await _loadFavoriteCoffeesUseCase.execute();
    failureOrCoffee.fold(
      (failure) => emit(
        state.copyWith(
          status: CoffeeStatus.error,
          coffee: Coffee.empty(),
        ),
      ),
      (coffee) => emit(
        state.copyWith(
          status: CoffeeStatus.loaded,
          coffee: coffee,
          favouriteCoffees: failureOrFavourites.getOrElse(() => []),
        ),
      ),
    );
  }

  Future<void> _onRefreshFavouriteCoffeeEvent(
    RefreshFavouriteCoffeeEvent event,
    Emitter<CoffeeState> emit,
  ) async {
    emit(state.copyWith(status: CoffeeStatus.loading));
    final failureOrFavourites = await _loadFavoriteCoffeesUseCase.execute();
    failureOrFavourites.fold(
      (failure) => emit(
        state.copyWith(
          status: CoffeeStatus.error,
          favouriteCoffees: [],
        ),
      ),
      (favourites) => emit(
        state.copyWith(
          status: CoffeeStatus.loaded,
          favouriteCoffees: favourites,
        ),
      ),
    );
  }
}
