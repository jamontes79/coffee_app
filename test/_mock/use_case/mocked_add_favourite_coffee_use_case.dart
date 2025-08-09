import 'package:coffee_app/coffee/domain/failure/coffee_failure.dart';
import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:coffee_app/coffee/domain/use_case/add_favourite_coffee_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';

class MockedAddFavouriteCoffeeUseCase extends Mock
    implements AddFavouriteCoffeeUseCase {
  void mockExecute(Coffee coffee) {
    when(() => execute(coffee)).thenAnswer((_) async => right(unit));
  }

  void mockLoadCoffeesError(Coffee coffee) {
    when(
      () => execute(coffee),
    ).thenAnswer((_) async => left(CoffeeNotFoundFailure()));
  }
}
