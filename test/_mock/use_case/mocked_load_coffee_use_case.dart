import 'package:coffee_app/coffee/domain/failure/coffee_failure.dart';
import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:coffee_app/coffee/domain/use_case/load_coffee_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';

class MockedLoadCoffeeUseCase extends Mock implements LoadCoffeeUseCase {
  void mockLoadCoffee(Coffee expected) {
    when(execute).thenAnswer((_) async => right(expected));
  }

  void mockLoadCoffeesError() {
    when(execute).thenAnswer((_) async => left(CoffeeNotFoundFailure()));
  }
}
