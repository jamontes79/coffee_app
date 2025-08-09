part of 'coffee_bloc.dart';

sealed class CoffeeEvent extends Equatable {
  const CoffeeEvent();
}

final class LoadCoffeeEvent extends CoffeeEvent {
  const LoadCoffeeEvent();

  @override
  List<Object?> get props => [];
}

final class RefreshFavouriteCoffeeEvent extends CoffeeEvent {
  const RefreshFavouriteCoffeeEvent();

  @override
  List<Object?> get props => [];
}

final class ToggleFavouriteCoffeeEvent extends CoffeeEvent {
  const ToggleFavouriteCoffeeEvent(this.coffee);

  final Coffee coffee;

  @override
  List<Object?> get props => [coffee];
}
