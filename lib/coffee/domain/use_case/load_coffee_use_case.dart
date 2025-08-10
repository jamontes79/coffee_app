import 'package:coffee_app/coffee/domain/failure/coffee_failure.dart';
import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:dartz/dartz.dart';

/// Use case for loading coffee data.
abstract class LoadCoffeeUseCase {
  Future<Either<CoffeeFailure, Coffee>> execute();
}
