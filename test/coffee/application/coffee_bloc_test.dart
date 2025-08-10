import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app/coffee/application/single/coffee_bloc.dart';
import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_mock/use_case/mocked_load_coffee_use_case.dart';

void main() {
  late MockedLoadCoffeeUseCase mockedLoadCoffeeUseCase;

  late CoffeeBloc bloc;

  setUp(() {
    mockedLoadCoffeeUseCase = MockedLoadCoffeeUseCase();
    bloc = CoffeeBloc(
      mockedLoadCoffeeUseCase,
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
          return bloc;
        },
        act: (CoffeeBloc bloc) => bloc.add(const LoadCoffeeEvent()),
        expect: () => [
          CoffeeState(
            status: CoffeeStatus.loading,
            coffee: Coffee.empty(),
          ),
          CoffeeState(
            status: CoffeeStatus.error,
            coffee: Coffee.empty(),
          ),
        ],
      );

      blocTest<CoffeeBloc, CoffeeState>(
        'should emits [loading, loaded] when the use case return right',
        build: () {
          mockedLoadCoffeeUseCase.mockLoadCoffee(
            const Coffee(url: 'https://example.com/coffee1.jpg'),
          );

          return bloc;
        },
        act: (CoffeeBloc bloc) => bloc.add(const LoadCoffeeEvent()),
        expect: () => [
          CoffeeState(
            status: CoffeeStatus.loading,
            coffee: Coffee.empty(),
          ),
          const CoffeeState(
            status: CoffeeStatus.loaded,
            coffee: Coffee(url: 'https://example.com/coffee1.jpg'),
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
  });
}
