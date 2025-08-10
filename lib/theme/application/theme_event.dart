part of 'theme_bloc.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();
}

final class LoadCoffeeEvent extends ThemeEvent {
  const LoadCoffeeEvent();

  @override
  List<Object?> get props => [];
}

final class RefreshFavouriteCoffeeEvent extends ThemeEvent {
  const RefreshFavouriteCoffeeEvent();

  @override
  List<Object?> get props => [];
}

final class ToggleFavouriteCoffeeEvent extends ThemeEvent {
  const ToggleFavouriteCoffeeEvent(this.coffee);

  final Coffee coffee;

  @override
  List<Object?> get props => [coffee];
}
