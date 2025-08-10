import 'dart:async';

import 'package:coffee_app/coffee/domain/failure/coffee_failure.dart';
import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:coffee_app/coffee/domain/use_case/add_favourite_coffee_use_case.dart';
import 'package:coffee_app/coffee/domain/use_case/load_favorite_coffees_use_case.dart';
import 'package:coffee_app/coffee/domain/use_case/remove_favourite_coffee_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

part 'favourite_coffee_event.dart';
part 'favourite_coffee_state.dart';

/// Bloc for managing the state of favourite coffees.
/// It handles loading, adding, and removing favourite coffees.
@injectable
class FavouriteCoffeeBloc
    extends Bloc<FavouriteCoffeeEvent, FavouriteCoffeeState> {
  FavouriteCoffeeBloc(
    this._loadFavoriteCoffeesUseCase,
    this._addFavouriteCoffeeUseCase,
    this._removeFavouriteCoffeeUseCase,
  ) : super(FavouriteCoffeeState.initial()) {
    on<LoadFavouriteCoffeesEvent>(_onLoadFavouriteCoffeesEvent);
    on<ToggleFavouriteCoffeeEvent>(_onToggleFavouriteCoffeeEvent);
  }

  final LoadFavoriteCoffeesUseCase _loadFavoriteCoffeesUseCase;
  final AddFavouriteCoffeeUseCase _addFavouriteCoffeeUseCase;
  final RemoveFavouriteCoffeeUseCase _removeFavouriteCoffeeUseCase;

  StreamSubscription<Either<CoffeeFailure, List<Coffee>>>?
  _favouritesSubscription;

  Future<void> _onLoadFavouriteCoffeesEvent(
    LoadFavouriteCoffeesEvent event,
    Emitter<FavouriteCoffeeState> emit,
  ) async {
    emit(state.copyWith(status: FavouriteCoffeeStatus.loading));
    await emit.forEach<Either<CoffeeFailure, List<Coffee>>>(
      _loadFavoriteCoffeesUseCase.execute(),
      onData: (failureOrFavourites) => failureOrFavourites.fold(
        (failure) => state.copyWith(
          status: FavouriteCoffeeStatus.error,
          favouriteCoffees: [],
        ),
        (favourites) => state.copyWith(
          status: FavouriteCoffeeStatus.loaded,
          favouriteCoffees: favourites,
        ),
      ),
    );
  }

  Future<void> _onToggleFavouriteCoffeeEvent(
    ToggleFavouriteCoffeeEvent event,
    Emitter<FavouriteCoffeeState> emit,
  ) async {
    late Either<CoffeeFailure, Unit> failureOrSuccess;
    if (state.favouriteCoffees.contains(event.coffee)) {
      failureOrSuccess = await _removeFavouriteCoffeeUseCase.execute(
        event.coffee,
      );
    } else {
      failureOrSuccess = await _addFavouriteCoffeeUseCase.execute(
        event.coffee,
      );
    }
    if (failureOrSuccess.isLeft()) {
      emit(state.copyWith(status: FavouriteCoffeeStatus.toggleError));
    }
  }

  @override
  Future<void> close() async {
    await _favouritesSubscription?.cancel();
    return super.close();
  }
}
