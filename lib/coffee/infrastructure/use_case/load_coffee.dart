import 'package:coffee_app/coffee/domain/failure/coffee_failure.dart';
import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:coffee_app/coffee/domain/use_case/load_coffee_use_case.dart';
import 'package:coffee_app/coffee/infrastructure/repository/coffee_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: LoadCoffeeUseCase)
class LoadCoffee implements LoadCoffeeUseCase {
  LoadCoffee(this._coffeeRepository);

  final CoffeeRepository _coffeeRepository;
  @override
  Future<Either<CoffeeFailure, Coffee>> execute() async {
    try {
      final coffeeData = await _coffeeRepository.fetchCoffeeData();

      final coffee = Coffee(url: coffeeData['file'] as String);
      return right(coffee);
    } on Exception catch (_) {
      return left(CoffeeNotFoundFailure());
    }
  }
}
