part of 'coffee_bloc.dart';

sealed class CoffeeState extends Equatable {
  const CoffeeState();
}

class CoffeeInitialState extends CoffeeState {
  const CoffeeInitialState();

  @override
  List<Object?> get props => [];
}

class CoffeeLoadingState extends CoffeeState {
  const CoffeeLoadingState();

  @override
  List<Object?> get props => [];
}

class CoffeeLoadedState extends CoffeeState {
  const CoffeeLoadedState(this.coffee);

  final Coffee coffee;

  @override
  List<Object?> get props => [coffee];
}

class CoffeeErrorState extends CoffeeState {
  const CoffeeErrorState();

  @override
  List<Object?> get props => [];
}
