import 'package:coffee_app/coffee/application/favourite/favourite_coffee_bloc.dart';
import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:coffee_app/coffee/presentation/favourite_coffees_page.dart';
import 'package:coffee_app/coffee/presentation/widgets/coffee_error_widget.dart';
import 'package:coffee_app/coffee/presentation/widgets/coffee_individual_widget.dart';
import 'package:coffee_app/coffee/presentation/widgets/favorite_coffees_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_mock/application/mocked_favourite_coffee_bloc.dart';
import '../../helpers/helpers.dart';

void main() {
  late MockedFavouriteCoffeeBloc mockedFavouriteCoffeeBloc;

  setUp(() {
    mockedFavouriteCoffeeBloc = MockedFavouriteCoffeeBloc();
  });

  group(FavouriteCoffeesPage, () {
    group('Loading', () {
      testWidgets(
        'should render CircularProgressIndicator when bloc.status is loading',
        (tester) async {
          mockedFavouriteCoffeeBloc.mockState(
            const FavouriteCoffeeState(
              status: FavouriteCoffeeStatus.loading,

              favouriteCoffees: [],
            ),
          );
          await tester.pumpApp(
            _TesterWidget(mockedFavouriteCoffeeBloc),
          );

          final placeholderFinder = find.byType(CircularProgressIndicator);

          expect(placeholderFinder, findsOneWidget);
        },
      );

      testWidgets(
        'should render CircularProgressIndicator when bloc.status is initial',
        (tester) async {
          mockedFavouriteCoffeeBloc.mockState(
            const FavouriteCoffeeState(
              status: FavouriteCoffeeStatus.initial,
              favouriteCoffees: [],
            ),
          );
          await tester.pumpApp(
            _TesterWidget(mockedFavouriteCoffeeBloc),
          );

          expect(find.byType(CircularProgressIndicator), findsOneWidget);
          expect(find.byType(CoffeeErrorWidget), findsNothing);
          expect(find.byType(CoffeeIndividualWidget), findsNothing);
        },
      );
    });

    group('Error', () {
      testWidgets(
        'should render CoffeeErrorWidget when bloc.status is error',
        (tester) async {
          mockedFavouriteCoffeeBloc.mockState(
            const FavouriteCoffeeState(
              status: FavouriteCoffeeStatus.error,
              favouriteCoffees: [],
            ),
          );
          await tester.pumpApp(
            _TesterWidget(mockedFavouriteCoffeeBloc),
          );

          expect(find.byType(CoffeeErrorWidget), findsOneWidget);
          expect(find.byType(CoffeeIndividualWidget), findsNothing);
          expect(find.byType(CircularProgressIndicator), findsNothing);
        },
      );
    });

    group('Loaded', () {
      testWidgets(
        'should render FavoriteCoffeesWidget when bloc.status is loaded',
        (tester) async {
          mockedFavouriteCoffeeBloc.mockState(
            const FavouriteCoffeeState(
              status: FavouriteCoffeeStatus.loaded,
              favouriteCoffees: [
                Coffee(
                  url: 'https://example.com/coffee.jpg',
                ),
              ],
            ),
          );
          await tester.pumpApp(
            _TesterWidget(mockedFavouriteCoffeeBloc),
          );

          expect(find.byType(CoffeeErrorWidget), findsNothing);
          expect(find.byType(FavoriteCoffeesWidget), findsOneWidget);
          expect(find.byType(CircularProgressIndicator), findsNothing);
        },
      );
    });
  });
}

class _TesterWidget extends StatelessWidget {
  const _TesterWidget(
    this.favouriteCoffeeBloc,
  );

  final FavouriteCoffeeBloc favouriteCoffeeBloc;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavouriteCoffeeBloc>.value(
      value: favouriteCoffeeBloc,
      child: const FavouriteCoffeesPage(),
    );
  }
}
