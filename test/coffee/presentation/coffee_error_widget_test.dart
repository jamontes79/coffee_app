import 'package:coffee_app/coffee/application/single/coffee_bloc.dart';
import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:coffee_app/coffee/presentation/widgets/coffee_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../_mock/application/mocked_coffee_bloc.dart';
import '../../helpers/helpers.dart';

void main() {
  final mockedCoffeeBloc = MockedCoffeeBloc();

  group(CoffeeErrorWidget, () {
    testWidgets(
      'should render error message and retry action',
      (tester) async {
        mockedCoffeeBloc.mockState(
          CoffeeState(
            status: CoffeeStatus.error,
            coffee: Coffee.empty(),
            favouriteCoffees: const [],
          ),
        );
        await tester.pumpApp(const CoffeeErrorWidget());

        expect(
          find.text('Error loading coffees'),
          findsOneWidget,
        );

        expect(find.byType(ElevatedButton), findsOneWidget);
      },
    );

    testWidgets(
      'should call CoffeeLoadEvent when retry button is pressed',
      (tester) async {
        mockedCoffeeBloc.mockState(
          CoffeeState(
            status: CoffeeStatus.error,
            coffee: Coffee.empty(),
            favouriteCoffees: const [],
          ),
        );
        await tester.pumpApp(
          BlocProvider<CoffeeBloc>.value(
            value: mockedCoffeeBloc,
            child: const CoffeeErrorWidget(),
          ),
        );

        final retryButton = find.byType(ElevatedButton);
        expect(retryButton, findsOneWidget);

        await tester.tap(retryButton);
        verify(() => mockedCoffeeBloc.add(const LoadCoffeeEvent())).called(1);
      },
    );
  });
}
