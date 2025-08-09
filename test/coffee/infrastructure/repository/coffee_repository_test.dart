import 'dart:convert';

import 'package:coffee_app/coffee/infrastructure/repository/coffee_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../../../_mock/third_party/mocked_get_storage.dart';
import '../../../_mock/third_party/mocked_http_client.dart';

void main() {
  const storageKey = 'favorite_coffees';
  late MockedHttpClient mockedHttpClient;
  late MockedGetStorage mockedGetStorage;
  late CoffeeRepository coffeeRepository;

  setUp(() {
    mockedHttpClient = MockedHttpClient();
    mockedGetStorage = MockedGetStorage();

    coffeeRepository = CoffeeRepository(mockedHttpClient, mockedGetStorage);
  });

  group(CoffeeRepository, () {
    group('fetchCoffeeData', () {
      test('fetchCoffeeData should return a Map with file URL', () async {
        mockedHttpClient.mockGet(
          uri: Uri.parse('https://coffee.alexflipnote.dev/random.json'),
          expected: http.Response(
            '{"file": "https://example.com/coffee.jpg"}',
            200,
            headers: {'Content-Type': 'application/json'},
          ),
        );

        final result = await coffeeRepository.fetchCoffeeData();

        expect(result, isA<Map<String, dynamic>>());
        expect(result['file'], 'https://example.com/coffee.jpg');
      });

      test('fetchCoffeeData should throw an exception on error', () async {
        mockedHttpClient.mockGet(
          uri: Uri.parse('https://coffee.alexflipnote.dev/random.json'),
          expected: http.Response('Not Found', 404),
        );

        expect(
          () async => coffeeRepository.fetchCoffeeData(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('saveFavoriteCoffee', () {
      test('saveFavoriteCoffee should save coffee to storage', () async {
        final coffee = {'file': 'https://example.com/coffee.jpg'};
        mockedGetStorage
          ..mockWrite(
            key: storageKey,
            value: [
              jsonEncode(coffee),
            ],
          )
          ..mockRead(key: storageKey, expected: null);

        await coffeeRepository.saveFavoriteCoffee(coffee);

        verify(
          () => mockedGetStorage.write(
            storageKey,
            [jsonEncode(coffee)],
          ),
        ).called(1);

        verify(
          () => mockedGetStorage.read<List<dynamic>>(storageKey),
        ).called(1);
      });
    });

    group('removeFavoriteCoffee', () {
      test('removeFavoriteCoffee should remove coffee from storage', () async {
        final coffee = {'file': 'https://example.com/coffee.jpg'};
        mockedGetStorage
          ..mockRead(
            key: storageKey,
            expected: [jsonEncode(coffee)],
          )
          ..mockWrite(
            key: storageKey,
            value: [],
          );

        await coffeeRepository.removeFavoriteCoffee(coffee);

        verify(
          () => mockedGetStorage.write(
            storageKey,
            <dynamic>[],
          ),
        ).called(1);

        verify(
          () => mockedGetStorage.read<List<dynamic>>(storageKey),
        ).called(1);
      });
    });

    group('getFavoriteCoffees', () {
      test(
        'getFavoriteCoffees should return a list of favorite coffees',
        () async {
          final coffee = {'file': 'https://example.com/coffee.jpg'};
          mockedGetStorage.mockRead(
            key: storageKey,
            expected: [jsonEncode(coffee)],
          );

          final result = await coffeeRepository.getFavoriteCoffees();

          expect(result, isA<List<Map<String, dynamic>>>());
          expect(result.length, 1);
          expect(result[0]['file'], 'https://example.com/coffee.jpg');
        },
      );

      test(
        'getFavoriteCoffees should return an empty list if no favorites',
        () async {
          mockedGetStorage.mockRead(key: storageKey, expected: null);

          final result = await coffeeRepository.getFavoriteCoffees();

          expect(result, isA<List<Map<String, dynamic>>>());
          expect(result.isEmpty, true);
        },
      );
    });
  });
}
