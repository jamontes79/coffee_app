import 'package:coffee_app/coffee/domain/failure/coffee_failure.dart';
import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:dartz/dartz.dart';

/// Use case for removing a coffee from the favourites list.
abstract class RemoveFavouriteCoffeeUseCase {
  Future<Either<CoffeeFailure, Unit>> execute(Coffee coffee);
}
