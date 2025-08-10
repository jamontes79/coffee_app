import 'package:coffee_app/coffee/application/favourite/favourite_coffee_bloc.dart';
import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:coffee_app/coffee/presentation/widgets/coffee_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../_mock/application/mocked_favourite_coffee_bloc.dart';
import '../../../helpers/helpers.dart';

void main() {
  const coffee = Coffee(
    url: 'https://example.com/espresso.jpg',
  );
  late MockedFavouriteCoffeeBloc mockedFavouriteCoffeeBloc;
  setUp(() {
    mockedFavouriteCoffeeBloc = MockedFavouriteCoffeeBloc();
  });

  group(CoffeeCardWidget, () {
    testWidgets(
      'should render with heart not filled '
      'when coffee is not favourite',
      (tester) async {
        mockedFavouriteCoffeeBloc.mockState(FavouriteCoffeeState.initial());
        await tester.pumpApp(
          BlocProvider<FavouriteCoffeeBloc>.value(
            value: mockedFavouriteCoffeeBloc,
            child: const CoffeeCardWidget(
              coffee: coffee,
            ),
          ),
        );

        expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      },
    );

    testWidgets(
      'should render with heart filled '
      'when coffee is favourite',
      (tester) async {
        mockedFavouriteCoffeeBloc.mockState(
          const FavouriteCoffeeState(
            status: FavouriteCoffeeStatus.loaded,
            favouriteCoffees: [coffee],
          ),
        );
        await tester.pumpApp(
          BlocProvider<FavouriteCoffeeBloc>.value(
            value: mockedFavouriteCoffeeBloc,
            child: const CoffeeCardWidget(
              coffee: coffee,
            ),
          ),
        );

        expect(find.byIcon(Icons.favorite), findsOneWidget);
      },
    );

    testWidgets(
      'should call toggle favourite coffee event '
      'when heart is pressed',
      (tester) async {
        mockedFavouriteCoffeeBloc.mockState(
          const FavouriteCoffeeState(
            status: FavouriteCoffeeStatus.loaded,
            favouriteCoffees: [],
          ),
        );

        await tester.pumpApp(
          BlocProvider<FavouriteCoffeeBloc>.value(
            value: mockedFavouriteCoffeeBloc,
            child: const CoffeeCardWidget(
              coffee: coffee,
            ),
          ),
        );

        await tester.tap(find.byIcon(Icons.favorite_border));
        await tester.pumpAndSettle();

        verify(
          () => mockedFavouriteCoffeeBloc.add(
            const ToggleFavouriteCoffeeEvent(coffee),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'should show snackbar with error message '
      'when toggle favourite coffee fails',
      (tester) async {
        mockedFavouriteCoffeeBloc
          ..mockState(
            const FavouriteCoffeeState(
              status: FavouriteCoffeeStatus.loaded,
              favouriteCoffees: [],
            ),
          )
          ..mockListen(
            [
              const FavouriteCoffeeState(
                status: FavouriteCoffeeStatus.toggleError,
                favouriteCoffees: [coffee],
              ),
            ],
          );

        await tester.pumpApp(
          BlocProvider<FavouriteCoffeeBloc>.value(
            value: mockedFavouriteCoffeeBloc,
            child: const Scaffold(
              body: CoffeeCardWidget(
                coffee: coffee,
              ),
            ),
          ),
        );

        await tester.pump();

        expect(find.text('Error toggling favourite coffee'), findsOneWidget);
      },
    );
  });
}
