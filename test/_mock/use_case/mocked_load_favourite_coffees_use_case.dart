import 'package:coffee_app/coffee/domain/failure/coffee_failure.dart';
import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:coffee_app/coffee/domain/use_case/load_favorite_coffees_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';

class MockedLoadFavouriteCoffeesUseCase extends Mock
    implements LoadFavoriteCoffeesUseCase {
  void mockExecute(List<Coffee> expected) {
    when(execute).thenAnswer((_) async => right(expected));
  }

  void mockLoadCoffeesError() {
    when(execute).thenAnswer((_) async => left(CoffeeNotFoundFailure()));
  }
}
