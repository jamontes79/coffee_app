import 'package:coffee_app/coffee/domain/failure/coffee_failure.dart';
import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:coffee_app/coffee/domain/use_case/remove_favourite_coffee_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';

class MockedRemoveFavouriteCoffeeUseCase extends Mock
    implements RemoveFavouriteCoffeeUseCase {
  void mockExecute(Coffee coffee) {
    when(() => execute(coffee)).thenAnswer((_) async => right(unit));
  }

  void mockRemoveCoffeeError(Coffee coffee) {
    when(
      () => execute(coffee),
    ).thenAnswer((_) async => left(RemoveFavouriteCoffeeFailure()));
  }
}
