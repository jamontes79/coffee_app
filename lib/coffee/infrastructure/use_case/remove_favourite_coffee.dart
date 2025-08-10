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
