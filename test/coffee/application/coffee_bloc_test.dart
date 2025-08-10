import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app/coffee/application/single/coffee_bloc.dart';
import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_mock/use_case/mocked_load_coffee_use_case.dart';
import '../../_mock/use_case/mocked_load_favourite_coffees_use_case.dart';

void main() {
  late MockedLoadCoffeeUseCase mockedLoadCoffeeUseCase;
  late MockedLoadFavouriteCoffeesUseCase mockedLoadFavouriteCoffeesUseCase;

  late CoffeeBloc bloc;

  setUp(() {
    mockedLoadFavouriteCoffeesUseCase = MockedLoadFavouriteCoffeesUseCase();

    mockedLoadCoffeeUseCase = MockedLoadCoffeeUseCase();
    bloc = CoffeeBloc(
      mockedLoadCoffeeUseCase,
      mockedLoadFavouriteCoffeesUseCase,
    );
  });

  group(CoffeeBloc, () {
    test('initial state is CoffeeState.initial', () {
      expect(bloc.state, CoffeeState.initial());
    });

    group(LoadCoffeeEvent, () {
      blocTest<CoffeeBloc, CoffeeState>(
        'should emits [loading, error] when the use case return left',
        build: () {
          mockedLoadCoffeeUseCase.mockLoadCoffeesError();
          mockedLoadFavouriteCoffeesUseCase.mockExecute([]);
          return bloc;
        },
        act: (CoffeeBloc bloc) => bloc.add(const LoadCoffeeEvent()),
        expect: () => [
          CoffeeState(
            status: CoffeeStatus.loading,
            coffee: Coffee.empty(),
            favouriteCoffees: const [],
          ),
          CoffeeState(
            status: CoffeeStatus.error,
            coffee: Coffee.empty(),
            favouriteCoffees: const [],
          ),
        ],
      );

      blocTest<CoffeeBloc, CoffeeState>(
        'should emits [loading, loaded] when the use case return right',
        build: () {
          mockedLoadCoffeeUseCase.mockLoadCoffee(
            const Coffee(url: 'https://example.com/coffee1.jpg'),
          );
          mockedLoadFavouriteCoffeesUseCase.mockExecute([
            const Coffee(url: 'https://example.com/coffee1.jpg'),
            const Coffee(url: 'https://example.com/coffee2.jpg'),
          ]);
          return bloc;
        },
        act: (CoffeeBloc bloc) => bloc.add(const LoadCoffeeEvent()),
        expect: () => [
          CoffeeState(
            status: CoffeeStatus.loading,
            coffee: Coffee.empty(),
            favouriteCoffees: const [],
          ),
          const CoffeeState(
            status: CoffeeStatus.loaded,
            coffee: Coffee(url: 'https://example.com/coffee1.jpg'),
            favouriteCoffees: [],
          ),
          const CoffeeState(
            status: CoffeeStatus.loadingFavourites,
            coffee: Coffee(url: 'https://example.com/coffee1.jpg'),
            favouriteCoffees: [],
          ),
          const CoffeeState(
            status: CoffeeStatus.loaded,
            coffee: Coffee(url: 'https://example.com/coffee1.jpg'),
            favouriteCoffees: [
              Coffee(url: 'https://example.com/coffee1.jpg'),
              Coffee(url: 'https://example.com/coffee2.jpg'),
            ],
          ),
        ],
      );
    });

    group(RefreshFavouriteCoffeeEvent, () {
      blocTest<CoffeeBloc, CoffeeState>(
        'should refresh favourite coffees',
        build: () {
          mockedLoadFavouriteCoffeesUseCase.mockExecute([
            const Coffee(url: 'https://example.com/coffee1.jpg'),
            const Coffee(url: 'https://example.com/coffee2.jpg'),
          ]);
          return bloc;
        },
        seed: () => const CoffeeState(
          status: CoffeeStatus.loaded,
          coffee: Coffee(url: 'https://example.com/coffee1.jpg'),
          favouriteCoffees: [],
        ),
        act: (CoffeeBloc bloc) {
          bloc.add(
            const RefreshFavouriteCoffeeEvent(),
          );
        },
        expect: () => [
          const CoffeeState(
            status: CoffeeStatus.loadingFavourites,
            coffee: Coffee(url: 'https://example.com/coffee1.jpg'),
            favouriteCoffees: [],
          ),
          const CoffeeState(
            status: CoffeeStatus.loaded,
            coffee: Coffee(url: 'https://example.com/coffee1.jpg'),
            favouriteCoffees: [
              Coffee(url: 'https://example.com/coffee1.jpg'),
              Coffee(url: 'https://example.com/coffee2.jpg'),
            ],
          ),
        ],
      );

      blocTest<CoffeeBloc, CoffeeState>(
        'should refresh favourite coffees with empty favourites when the '
        'use case returns error',
        build: () {
          mockedLoadFavouriteCoffeesUseCase.mockLoadCoffeesError();
          return bloc;
        },
        seed: () => const CoffeeState(
          status: CoffeeStatus.loaded,
          coffee: Coffee(url: 'https://example.com/coffee1.jpg'),
          favouriteCoffees: [],
        ),
        act: (CoffeeBloc bloc) {
          bloc.add(
            const RefreshFavouriteCoffeeEvent(),
          );
        },
        expect: () => [
          const CoffeeState(
            status: CoffeeStatus.loadingFavourites,
            coffee: Coffee(url: 'https://example.com/coffee1.jpg'),
            favouriteCoffees: [],
          ),
          const CoffeeState(
            status: CoffeeStatus.error,
            coffee: Coffee(url: 'https://example.com/coffee1.jpg'),
            favouriteCoffees: [],
          ),
        ],
      );
    });
  });

  group(CoffeeEvent, () {
    test('LoadCoffeesEvent is comparable', () {
      const event1 = LoadCoffeeEvent();
      const event2 = LoadCoffeeEvent();

      expect(event1 == event2, isTrue);
      expect(event1.props, event2.props);
    });

    test('RefreshFavouriteCoffeeEvent is comparable', () {
      const event1 = RefreshFavouriteCoffeeEvent();
      const event2 = RefreshFavouriteCoffeeEvent();

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
