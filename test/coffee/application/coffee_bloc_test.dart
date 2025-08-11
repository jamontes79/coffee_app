import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app/coffee/application/single/coffee_bloc.dart';
import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_mock/use_case/mocked_load_coffee_use_case.dart';

void main() {
  late MockedLoadCoffeeUseCase mockedLoadCoffeeUseCase;
  late CoffeeBloc bloc;
  const coffee = Coffee(url: 'https://example.com/coffee1.jpg');

  setUp(() {
    mockedLoadCoffeeUseCase = MockedLoadCoffeeUseCase();
    bloc = CoffeeBloc(
      mockedLoadCoffeeUseCase,
    );
  });

  group(CoffeeBloc, () {
    test('initial state is CoffeeInitialState', () {
      expect(bloc.state, const CoffeeInitialState());
    });

    group(LoadCoffeeEvent, () {
      blocTest<CoffeeBloc, CoffeeState>(
        'should emits [loading, error] when the use case return left',
        build: () {
          mockedLoadCoffeeUseCase.mockLoadCoffeesError();
          return bloc;
        },
        act: (CoffeeBloc bloc) => bloc.add(const LoadCoffeeEvent()),
        expect: () => [
          const CoffeeLoadingState(),
          const CoffeeErrorState(),
        ],
      );

      blocTest<CoffeeBloc, CoffeeState>(
        'should emits [loading, loaded] when the use case return right',
        build: () {
          mockedLoadCoffeeUseCase.mockLoadCoffee(coffee);

          return bloc;
        },
        act: (CoffeeBloc bloc) => bloc.add(const LoadCoffeeEvent()),
        expect: () => [
          const CoffeeLoadingState(),
          const CoffeeLoadedState(coffee),
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
  });

  group(CoffeeState, () {
    test('CoffeeInitialState is comparable', () {
      const state1 = CoffeeInitialState();
      const state2 = CoffeeInitialState();

      expect(state1 == state2, isTrue);
      expect(state1.props, state2.props);
    });

    test('CoffeeLoadingState is comparable', () {
      const state1 = CoffeeLoadingState();
      const state2 = CoffeeLoadingState();

      expect(state1 == state2, isTrue);
      expect(state1.props, state2.props);
    });

    test('CoffeeLoadedState is comparable', () {
      const state1 = CoffeeLoadedState(coffee);
      const state2 = CoffeeLoadedState(coffee);

      expect(state1 == state2, isTrue);
      expect(state1.props, state2.props);
    });

    test('CoffeeErrorState is comparable', () {
      const state1 = CoffeeErrorState();
      const state2 = CoffeeErrorState();

      expect(state1 == state2, isTrue);
      expect(state1.props, state2.props);
    });
  });
}
