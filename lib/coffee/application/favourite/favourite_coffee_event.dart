part of 'favourite_coffee_bloc.dart';

sealed class FavouriteCoffeeEvent extends Equatable {
  const FavouriteCoffeeEvent();
}

final class LoadFavouriteCoffeesEvent extends FavouriteCoffeeEvent {
  const LoadFavouriteCoffeesEvent();

  @override
  List<Object?> get props => [];
}

final class ToggleFavouriteCoffeeEvent extends FavouriteCoffeeEvent {
  const ToggleFavouriteCoffeeEvent(this.coffee);

  final Coffee coffee;

  @override
  List<Object?> get props => [coffee];
}
