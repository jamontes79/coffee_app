import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app/coffee/application/favourite/favourite_coffee_bloc.dart';
import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_mock/use_case/mocked_add_favourite_coffee_use_case.dart';
import '../../_mock/use_case/mocked_load_favourite_coffees_use_case.dart';
import '../../_mock/use_case/mocked_remove_favourite_coffee_use_case.dart';

void main() {
  late MockedLoadFavouriteCoffeesUseCase mockedLoadFavouriteCoffeesUseCase;
  late MockedAddFavouriteCoffeeUseCase mockedAddFavouriteCoffeeUseCase;
  late MockedRemoveFavouriteCoffeeUseCase mockedRemoveFavouriteCoffeeUseCase;

  late FavouriteCoffeeBloc bloc;

  setUp(() {
    mockedLoadFavouriteCoffeesUseCase = MockedLoadFavouriteCoffeesUseCase();
    mockedAddFavouriteCoffeeUseCase = MockedAddFavouriteCoffeeUseCase();
    mockedRemoveFavouriteCoffeeUseCase = MockedRemoveFavouriteCoffeeUseCase();

    bloc = FavouriteCoffeeBloc(
      mockedLoadFavouriteCoffeesUseCase,
      mockedAddFavouriteCoffeeUseCase,
      mockedRemoveFavouriteCoffeeUseCase,
    );
  });

  group(FavouriteCoffeeBloc, () {
    test('initial state is FavouriteCoffeeState.initial', () {
      expect(bloc.state, FavouriteCoffeeState.initial());
    });

    group(LoadFavouriteCoffeesEvent, () {
      blocTest<FavouriteCoffeeBloc, FavouriteCoffeeState>(
        'should emits [loading, error] when the use case return left',
        build: () {
          mockedLoadFavouriteCoffeesUseCase.mockLoadCoffeesError();
          return bloc;
        },
        act: (FavouriteCoffeeBloc bloc) =>
            bloc.add(const LoadFavouriteCoffeesEvent()),
        expect: () => [
          const FavouriteCoffeeState(
            status: FavouriteCoffeeStatus.loading,
            favouriteCoffees: [],
          ),
          const FavouriteCoffeeState(
            status: FavouriteCoffeeStatus.error,
            favouriteCoffees: [],
          ),
        ],
      );

      blocTest<FavouriteCoffeeBloc, FavouriteCoffeeState>(
        'should emits [loading, loaded] when the use case return right',
        build: () {
          mockedLoadFavouriteCoffeesUseCase.mockExecute([
            const Coffee(url: 'https://example.com/coffee1.jpg'),
            const Coffee(url: 'https://example.com/coffee2.jpg'),
          ]);
          return bloc;
        },
        act: (FavouriteCoffeeBloc bloc) =>
            bloc.add(const LoadFavouriteCoffeesEvent()),
        expect: () => [
          const FavouriteCoffeeState(
            status: FavouriteCoffeeStatus.loading,

            favouriteCoffees: [],
          ),
          const FavouriteCoffeeState(
            status: FavouriteCoffeeStatus.loaded,

            favouriteCoffees: [
              Coffee(url: 'https://example.com/coffee1.jpg'),
              Coffee(url: 'https://example.com/coffee2.jpg'),
            ],
          ),
        ],
      );
    });

    group(ToggleFavouriteCoffeeEvent, () {
      blocTest<FavouriteCoffeeBloc, FavouriteCoffeeState>(
        'should emits [loading, loaded] when the use case return right '
        'and the coffee is in the favourites',
        build: () {
          mockedLoadFavouriteCoffeesUseCase.mockExecute([
            const Coffee(url: 'https://example.com/coffee2.jpg'),
          ]);
          mockedRemoveFavouriteCoffeeUseCase.mockExecute(
            const Coffee(url: 'https://example.com/coffee1.jpg'),
          );
          return bloc;
        },
        seed: () => const FavouriteCoffeeState(
          status: FavouriteCoffeeStatus.loaded,
          favouriteCoffees: [
            Coffee(url: 'https://example.com/coffee1.jpg'),
            Coffee(url: 'https://example.com/coffee2.jpg'),
          ],
        ),
        act: (FavouriteCoffeeBloc bloc) => bloc.add(
          const ToggleFavouriteCoffeeEvent(
            const Coffee(url: 'https://example.com/coffee1.jpg'),
          ),
        ),
        expect: () => [
          const FavouriteCoffeeState(
            status: FavouriteCoffeeStatus.loading,

            favouriteCoffees: [
              Coffee(url: 'https://example.com/coffee1.jpg'),
              Coffee(url: 'https://example.com/coffee2.jpg'),
            ],
          ),
          const FavouriteCoffeeState(
            status: FavouriteCoffeeStatus.loaded,
            favouriteCoffees: [
              Coffee(url: 'https://example.com/coffee2.jpg'),
            ],
          ),
        ],
      );

      blocTest<FavouriteCoffeeBloc, FavouriteCoffeeState>(
        'should emits [loading, loaded] when the use case return right '
        'and the coffee is not in the favourites',
        build: () {
          mockedLoadFavouriteCoffeesUseCase.mockExecute([
            const Coffee(url: 'https://example.com/coffee2.jpg'),
            const Coffee(url: 'https://example.com/coffee1.jpg'),
          ]);
          mockedAddFavouriteCoffeeUseCase.mockExecute(
            const Coffee(url: 'https://example.com/coffee1.jpg'),
          );
          return bloc;
        },
        seed: () => const FavouriteCoffeeState(
          status: FavouriteCoffeeStatus.loaded,
          favouriteCoffees: [
            Coffee(url: 'https://example.com/coffee2.jpg'),
          ],
        ),
        act: (FavouriteCoffeeBloc bloc) => bloc.add(
          const ToggleFavouriteCoffeeEvent(
            const Coffee(url: 'https://example.com/coffee1.jpg'),
          ),
        ),
        expect: () => [
          const FavouriteCoffeeState(
            status: FavouriteCoffeeStatus.loading,
            favouriteCoffees: [
              Coffee(url: 'https://example.com/coffee2.jpg'),
            ],
          ),
          const FavouriteCoffeeState(
            status: FavouriteCoffeeStatus.loaded,
            favouriteCoffees: [
              Coffee(url: 'https://example.com/coffee2.jpg'),
              Coffee(url: 'https://example.com/coffee1.jpg'),
            ],
          ),
        ],
      );
    });
  });

  group(FavouriteCoffeeEvent, () {
    test('LoadCoffeesEvent is comparable', () {
      const event1 = LoadFavouriteCoffeesEvent();
      const event2 = LoadFavouriteCoffeesEvent();

      expect(event1 == event2, isTrue);
      expect(event1.props, event2.props);
    });

    test('ToggleFavouriteCoffeeEvent is comparable', () {
      const coffee = Coffee(url: 'https://example.com/coffee.jpg');
      const event1 = ToggleFavouriteCoffeeEvent(coffee);
      const event2 = ToggleFavouriteCoffeeEvent(coffee);

      expect(event1 == event2, isTrue);
      expect(event1.props, event2.props);
    });
  });
}
