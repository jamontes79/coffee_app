import 'package:coffee_app/coffee/domain/failure/coffee_failure.dart';
import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:coffee_app/coffee/infrastructure/use_case/load_favourite_coffees.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../_mock/repository/mocked_coffee_repository.dart';

void main() {
  late MockedCoffeeRepository mockedCoffeeRepository;
  late LoadFavouriteCoffees loadFavouriteCoffee;

  setUp(() {
    mockedCoffeeRepository = MockedCoffeeRepository();
    loadFavouriteCoffee = LoadFavouriteCoffees(mockedCoffeeRepository);
  });

  group(LoadFavouriteCoffees, () {
    group('execute', () {
      test('should call getFavoriteCoffees', () async {
        mockedCoffeeRepository.mockGetFavouriteCoffees(
          expected: {'url': 'https://example.com/coffee.jpg'},
        );

        await loadFavouriteCoffee.execute();

        verify(() => mockedCoffeeRepository.getFavoriteCoffees()).called(1);
        verifyNoMoreInteractions(mockedCoffeeRepository);
      });

      test('should return a Coffee', () async {
        mockedCoffeeRepository.mockGetFavouriteCoffees(
          expected: {'url': 'https://example.com/coffee1.jpg'},
        );

        final result = await loadFavouriteCoffee.execute();

        result.fold(
          (failure) => fail('Expected right, got left: $failure'),
          (coffee) {
            expect(
              coffee,
              [const Coffee(url: 'https://example.com/coffee1.jpg')],
            );
          },
        );
      });

      test('should return CoffeeNotFoundFailure on error', () async {
        mockedCoffeeRepository.mockGetFavouriteCoffeesError();

        final result = await loadFavouriteCoffee.execute();

        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, isA<CoffeeNotFoundFailure>()),
          (coffees) => fail('Expected left, got right: $coffees'),
        );
      });
    });
  });
}
