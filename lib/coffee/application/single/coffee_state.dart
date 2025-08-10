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
  });

  factory CoffeeState.initial() {
    return CoffeeState(
      status: CoffeeStatus.initial,
      coffee: Coffee.empty(),
    );
  }

  final CoffeeStatus status;
  final Coffee coffee;

  @override
  List<Object?> get props => [
    status,
    coffee,
  ];

  CoffeeState copyWith({
    required CoffeeStatus status,
    Coffee? coffee,
  }) {
    return CoffeeState(
      status: status,
      coffee: coffee ?? this.coffee,
    );
  }
}
