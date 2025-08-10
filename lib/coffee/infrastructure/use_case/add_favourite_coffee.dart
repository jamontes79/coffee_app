import 'package:coffee_app/coffee/domain/failure/coffee_failure.dart';
import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:coffee_app/coffee/domain/use_case/add_favourite_coffee_use_case.dart';
import 'package:coffee_app/coffee/infrastructure/repository/coffee_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AddFavouriteCoffeeUseCase)
class AddFavouriteCoffee implements AddFavouriteCoffeeUseCase {
  AddFavouriteCoffee(this._coffeeRepository);

  final CoffeeRepository _coffeeRepository;

  @override
  Future<Either<CoffeeFailure, Unit>> execute(Coffee coffee) async {
    try {
      await _coffeeRepository.saveFavoriteCoffee(coffee.toJson());

      return right(unit);
    } on Exception catch (_) {
      return left(AddFavouriteCoffeeFailure());
    }
  }
}
