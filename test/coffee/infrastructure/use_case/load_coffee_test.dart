import 'package:coffee_app/coffee/domain/failure/coffee_failure.dart';
import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:coffee_app/coffee/infrastructure/use_case/load_coffee.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../_mock/repository/mocked_coffee_repository.dart';

void main() {
  late MockedCoffeeRepository mockedCoffeeRepository;
  late LoadCoffee loadCoffee;

  setUp(() {
    mockedCoffeeRepository = MockedCoffeeRepository();
    loadCoffee = LoadCoffee(mockedCoffeeRepository);
  });

  group(LoadCoffee, () {
    group('execute', () {
      test('should call fetchCoffeeData', () async {
        mockedCoffeeRepository.mockFetchCoffeeData(
          expected: {'file': 'https://example.com/coffee.jpg'},
        );

        await loadCoffee.execute();

        verify(() => mockedCoffeeRepository.fetchCoffeeData()).called(1);
        verifyNoMoreInteractions(mockedCoffeeRepository);
      });

      test('should return a Coffee', () async {
        mockedCoffeeRepository.mockFetchCoffeeData(
          expected: {'file': 'https://example.com/coffee1.jpg'},
        );

        final result = await loadCoffee.execute();

        result.fold(
          (failure) => fail('Expected right, got left: $failure'),
          (coffee) {
            expect(
              coffee,
              const Coffee(url: 'https://example.com/coffee1.jpg'),
            );
          },
        );
      });

      test('should return CoffeeNotFoundFailure on error', () async {
        mockedCoffeeRepository.mockFetchCoffeeDataError();

        final result = await loadCoffee.execute();

        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, isA<CoffeeNotFoundFailure>()),
          (coffees) => fail('Expected left, got right: $coffees'),
        );
      });
    });
  });
}
