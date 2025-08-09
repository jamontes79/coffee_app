import 'package:coffee_app/coffee/domain/failure/coffee_failure.dart';
import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:dartz/dartz.dart';

abstract class LoadFavoriteCoffeesUseCase {
  Future<Either<CoffeeFailure, List<Coffee>>> execute();
}
