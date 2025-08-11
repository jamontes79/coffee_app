import 'package:coffee_app/coffee/domain/failure/coffee_failure.dart';
import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:coffee_app/coffee/domain/use_case/remove_favourite_coffee_use_case.dart';
import 'package:coffee_app/coffee/infrastructure/repository/coffee_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: RemoveFavouriteCoffeeUseCase)
class RemoveFavouriteCoffee implements RemoveFavouriteCoffeeUseCase {
  RemoveFavouriteCoffee(this._coffeeRepository);

  final CoffeeRepository _coffeeRepository;

  /// Executes the use case to remove a coffee from the favourites list.
  /// Returns a [Future] that completes with either
  /// a [CoffeeFailure] or a [Unit].
  /// If the coffee is successfully removed, it returns [right(unit)].
  /// If an error occurs, it returns [left(RemoveFavouriteCoffeeFailure())].
  @override
  Future<Either<CoffeeFailure, Unit>> execute(Coffee coffee) async {
    try {
      await _coffeeRepository.removeFavoriteCoffee(coffee.toJson());

      return right(unit);
    } on Exception catch (_) {
      return left(RemoveFavouriteCoffeeFailure());
    }
  }
}
