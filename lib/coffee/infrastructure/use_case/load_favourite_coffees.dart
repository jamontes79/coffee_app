import 'package:coffee_app/coffee/domain/failure/coffee_failure.dart';
import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:coffee_app/coffee/domain/use_case/load_favorite_coffees_use_case.dart';
import 'package:coffee_app/coffee/infrastructure/repository/coffee_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: LoadFavoriteCoffeesUseCase)
class LoadFavouriteCoffees implements LoadFavoriteCoffeesUseCase {
  LoadFavouriteCoffees(this._coffeeRepository);

  final CoffeeRepository _coffeeRepository;

  @override
  Stream<Either<CoffeeFailure, List<Coffee>>> execute() async* {
    try {
      yield* _coffeeRepository.getFavoriteCoffees().map((coffeesData) {
        final coffees = coffeesData.map((coffeeData) {
          return Coffee(url: coffeeData['url'] as String);
        }).toList();
        return right(coffees);
      });
    } on Exception catch (_) {
      yield left(CoffeeNotFoundFailure());
    }
  }
}
