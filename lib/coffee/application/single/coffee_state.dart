part of 'coffee_bloc.dart';

enum CoffeeStatus {
  initial,
  loading,
  loaded,
  error,
}

final class CoffeeState extends Equatable {
  const CoffeeState({
    required this.status,
    required this.coffee,
    required this.favouriteCoffees,
  });

  factory CoffeeState.initial() {
    return CoffeeState(
      status: CoffeeStatus.initial,
      coffee: Coffee.empty(),
      favouriteCoffees: const [],
    );
  }

  final CoffeeStatus status;
  final Coffee coffee;
  final List<Coffee> favouriteCoffees;

  @override
  List<Object?> get props => [
    status,
    coffee,
    favouriteCoffees,
  ];

  CoffeeState copyWith({
    required CoffeeStatus status,
    Coffee? coffee,
    List<Coffee>? favouriteCoffees,
  }) {
    return CoffeeState(
      status: status,
      coffee: coffee ?? this.coffee,
      favouriteCoffees: favouriteCoffees ?? this.favouriteCoffees,
    );
  }
}
