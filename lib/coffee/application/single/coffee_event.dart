part of 'coffee_bloc.dart';

sealed class CoffeeEvent extends Equatable {
  const CoffeeEvent();
}

final class LoadCoffeeEvent extends CoffeeEvent {
  const LoadCoffeeEvent();

  @override
  List<Object?> get props => [];
}
