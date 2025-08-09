import 'package:coffee_app/coffee/infrastructure/repository/coffee_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/when_extension.dart';

class MockedCoffeeRepository extends Mock implements CoffeeRepository {
  void mockFetchCoffeeData({
    required Map<String, dynamic> expected,
  }) {
    when(fetchCoffeeData).thenAnswer((_) async => expected);
  }

  void mockFetchCoffeeDataConsecutive({
    required List<Map<String, dynamic>> expected,
  }) {
    when(fetchCoffeeData).thenAnswerMany(
      expected
          .map(
            (value) =>
                (invocation) => Future.value(value),
          )
          .toList(),
    );
  }

  void mockFetchCoffeeDataError() {
    when(fetchCoffeeData).thenThrow(Exception('Failed to fetch coffee data'));
  }

  void mockGetFavouriteCoffees({required Map<String, String> expected}) {
    when(getFavoriteCoffees).thenAnswer((_) async => [expected]);
  }

  void mockGetFavouriteCoffeesError() {
    when(
      getFavoriteCoffees,
    ).thenThrow(Exception('Failed to get favorite coffees'));
  }

  void mockSaveFavouriteCoffee({required Map<String, String> value}) {
    when(() => saveFavoriteCoffee(value)).thenAnswer((_) async => {});
  }

  void mockSaveFavouriteCoffeesError() {
    when(
      () => saveFavoriteCoffee(any()),
    ).thenThrow(Exception('Failed to save coffee'));
  }

  void mockRemoveFavouriteCoffee({required Map<String, String> value}) {
    when(() => removeFavoriteCoffee(value)).thenAnswer((_) async => {});
  }

  void mockRemoveFavouriteCoffeeError() {
    when(
      () => removeFavoriteCoffee(any()),
    ).thenThrow(Exception('Failed to remove coffee'));
  }
}
