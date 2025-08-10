import 'package:coffee_app/coffee/domain/failure/coffee_failure.dart';
import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:coffee_app/coffee/infrastructure/use_case/remove_favourite_coffee.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../_mock/repository/mocked_coffee_repository.dart';

void main() {
  late MockedCoffeeRepository mockedCoffeeRepository;
  late RemoveFavouriteCoffee removeFavouriteCoffee;

  setUp(() {
    mockedCoffeeRepository = MockedCoffeeRepository();
    removeFavouriteCoffee = RemoveFavouriteCoffee(mockedCoffeeRepository);
  });

  group(RemoveFavouriteCoffee, () {
    group('execute', () {
      test('should call removeFavoriteCoffee', () async {
        mockedCoffeeRepository.mockRemoveFavouriteCoffee(
          value: {'url': 'https://example.com/coffee.jpg'},
        );

        await removeFavouriteCoffee.execute(
          const Coffee(url: 'https://example.com/coffee.jpg'),
        );

        verify(
          () => mockedCoffeeRepository.removeFavoriteCoffee({
            'url': 'https://example.com/coffee.jpg',
          }),
        ).called(1);
        verifyNoMoreInteractions(mockedCoffeeRepository);
      });

      test('should return unit', () async {
        mockedCoffeeRepository.mockRemoveFavouriteCoffee(
          value: {'url': 'https://example.com/coffee.jpg'},
        );

        final result = await removeFavouriteCoffee.execute(
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
        mockedCoffeeRepository.mockRemoveFavouriteCoffeeError();

        final result = await removeFavouriteCoffee.execute(
          const Coffee(url: 'https://example.com/coffee.jpg'),
        );

        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, isA<RemoveFavouriteCoffeeFailure>()),
          (coffees) => fail('Expected left, got right: $coffees'),
        );
      });
    });
  });
}
