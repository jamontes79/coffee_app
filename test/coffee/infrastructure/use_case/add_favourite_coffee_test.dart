import 'package:coffee_app/coffee/domain/failure/coffee_failure.dart';
import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:coffee_app/coffee/infrastructure/use_case/add_favourite_coffee.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../_mock/repository/mocked_coffee_repository.dart';

void main() {
  late MockedCoffeeRepository mockedCoffeeRepository;
  late AddFavouriteCoffee addFavouriteCoffee;

  setUp(() {
    mockedCoffeeRepository = MockedCoffeeRepository();
    addFavouriteCoffee = AddFavouriteCoffee(mockedCoffeeRepository);
  });

  group(AddFavouriteCoffee, () {
    group('execute', () {
      test('should call saveFavoriteCoffee', () async {
        mockedCoffeeRepository.mockSaveFavouriteCoffee(
          value: {'url': 'https://example.com/coffee.jpg'},
        );

        await addFavouriteCoffee.execute(
          const Coffee(url: 'https://example.com/coffee.jpg'),
        );

        verify(
          () => mockedCoffeeRepository.saveFavoriteCoffee({
            'url': 'https://example.com/coffee.jpg',
          }),
        ).called(1);
        verifyNoMoreInteractions(mockedCoffeeRepository);
      });

      test('should return unit', () async {
        mockedCoffeeRepository.mockSaveFavouriteCoffee(
          value: {'url': 'https://example.com/coffee.jpg'},
        );

        final result = await addFavouriteCoffee.execute(
          const Coffee(url: 'https://example.com/coffee.jpg'),
        );

        result.fold(
          (failure) => fail('Expected right, got left: $failure'),
          (value) {
            expect(
              value,
              unit,
            );
          },
        );
      });

      test('should return CoffeeNotFoundFailure on error', () async {
        mockedCoffeeRepository.mockSaveFavouriteCoffeesError();

        final result = await addFavouriteCoffee.execute(
          const Coffee(url: 'https://example.com/coffee.jpg'),
        );

        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, isA<AddFavouriteCoffeeFailure>()),
          (coffees) => fail('Expected left, got right: $coffees'),
        );
      });
    });
  });
}
