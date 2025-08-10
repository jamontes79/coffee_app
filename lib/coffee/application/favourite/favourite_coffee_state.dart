part of 'favourite_coffee_bloc.dart';

enum FavouriteCoffeeStatus {
  initial,
  loading,
  loaded,
  error,
  toggleError,
}

final class FavouriteCoffeeState extends Equatable {
  const FavouriteCoffeeState({
    required this.status,
    required this.favouriteCoffees,
  });

  factory FavouriteCoffeeState.initial() {
    return const FavouriteCoffeeState(
      status: FavouriteCoffeeStatus.initial,
      favouriteCoffees: [],
    );
  }

  final FavouriteCoffeeStatus status;
  final List<Coffee> favouriteCoffees;

  @override
  List<Object?> get props => [
    status,
    favouriteCoffees,
  ];

  FavouriteCoffeeState copyWith({
    required FavouriteCoffeeStatus status,
    Coffee? coffee,
    List<Coffee>? favouriteCoffees,
  }) {
    return FavouriteCoffeeState(
      status: status,
      favouriteCoffees: favouriteCoffees ?? this.favouriteCoffees,
    );
  }
}
