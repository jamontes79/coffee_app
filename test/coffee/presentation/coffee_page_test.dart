import 'package:coffee_app/coffee/application/favourite/favourite_coffee_bloc.dart';
import 'package:coffee_app/coffee/application/single/coffee_bloc.dart';
import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:coffee_app/coffee/presentation/coffee_page.dart';
import 'package:coffee_app/coffee/presentation/widgets/coffee_error_widget.dart';
import 'package:coffee_app/coffee/presentation/widgets/coffee_individual_widget.dart';
import 'package:coffee_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_mock/application/mocked_coffee_bloc.dart';
import '../../_mock/application/mocked_favourite_coffee_bloc.dart';
import '../../helpers/helpers.dart';
import '../../helpers/mock_go_router_provider.dart';

void main() {
  late MockGoRouter mockGoRouter;
  late MockedCoffeeBloc mockedCoffeeBloc;
  late MockedFavouriteCoffeeBloc mockedFavouriteCoffeeBloc;

  setUp(() {
    mockGoRouter = MockGoRouter();
    mockedCoffeeBloc = MockedCoffeeBloc();
    mockedFavouriteCoffeeBloc = MockedFavouriteCoffeeBloc()
      ..mockState(
        const FavouriteCoffeeState(
          status: FavouriteCoffeeStatus.initial,
          favouriteCoffees: [],
        ),
      );
  });

  group(CoffeePage, () {
    group('Menu', () {
      testWidgets(
        'should display a popup menu with "Favourite Coffees" option',
        (tester) async {
          mockedCoffeeBloc.mockState(
            const CoffeeState(
              status: CoffeeStatus.loaded,
              coffee: Coffee(
                url: 'https://example.com/coffee.jpg',
              ),
              favouriteCoffees: [],
            ),
          );
          await tester.pumpApp(
            _TesterWidget(mockedCoffeeBloc, mockedFavouriteCoffeeBloc),
          );

          await tester.pumpAndSettle();

          await tester.tap(find.byType(PopupMenuButton<String>));
          await tester.pumpAndSettle();
          expect(find.byType(PopupMenuItem<String>), findsOneWidget);

          expect(find.text('Favourite Coffees'), findsOneWidget);
        },
      );

      testWidgets(
        'should navigate to "Favourite Coffees" page when selected',
        (tester) async {
          mockedCoffeeBloc.mockState(
            const CoffeeState(
              status: CoffeeStatus.loaded,
              coffee: Coffee(
                url: 'https://example.com/coffee.jpg',
              ),
              favouriteCoffees: [],
            ),
          );
          await tester.pumpApp(
            MockGoRouterProvider(
              goRouter: mockGoRouter,
              child: _TesterWidget(mockedCoffeeBloc, mockedFavouriteCoffeeBloc),
            ),
          );

          await tester.pumpAndSettle();

          await tester.tap(find.byType(PopupMenuButton<String>));
          await tester.pumpAndSettle();

          await tester.tap(find.text('Favourite Coffees'));
          await tester.pumpAndSettle();

          mockGoRouter.mockGo(CoffeeRoutes.favouritesPage);
        },
      );
    });
    group('Loading', () {
      testWidgets(
        'should render CircularProgressIndicator when bloc.status is loading',
        (tester) async {
          mockedCoffeeBloc.mockState(
            CoffeeState(
              status: CoffeeStatus.loading,
              coffee: Coffee.empty(),
              favouriteCoffees: const [],
            ),
          );
          await tester.pumpApp(
            _TesterWidget(mockedCoffeeBloc, mockedFavouriteCoffeeBloc),
          );

          final placeholderFinder = find.byType(CircularProgressIndicator);

          expect(placeholderFinder, findsOneWidget);
        },
      );

      testWidgets(
        'should render CircularProgressIndicator when bloc.status is initial',
        (tester) async {
          mockedCoffeeBloc.mockState(
            CoffeeState(
              status: CoffeeStatus.initial,
              coffee: Coffee.empty(),
              favouriteCoffees: const [],
            ),
          );
          await tester.pumpApp(
            _TesterWidget(mockedCoffeeBloc, mockedFavouriteCoffeeBloc),
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
          mockedCoffeeBloc.mockState(
            CoffeeState(
              status: CoffeeStatus.error,
              coffee: Coffee.empty(),
              favouriteCoffees: const [],
            ),
          );
          await tester.pumpApp(
            _TesterWidget(mockedCoffeeBloc, mockedFavouriteCoffeeBloc),
          );

          expect(find.byType(CoffeeErrorWidget), findsOneWidget);
          expect(find.byType(CoffeeIndividualWidget), findsNothing);
          expect(find.byType(CircularProgressIndicator), findsNothing);
        },
      );
    });

    group('Loaded', () {
      testWidgets(
        'should render CoffeeIndividualWidget when bloc.status is loaded',
        (tester) async {
          mockedCoffeeBloc.mockState(
            const CoffeeState(
              status: CoffeeStatus.loaded,
              coffee: Coffee(
                url: 'https://example.com/coffee.jpg',
              ),
              favouriteCoffees: [],
            ),
          );
          await tester.pumpApp(
            _TesterWidget(mockedCoffeeBloc, mockedFavouriteCoffeeBloc),
          );

          expect(find.byType(CoffeeErrorWidget), findsNothing);
          expect(find.byType(CoffeeIndividualWidget), findsOneWidget);
          expect(find.byType(CircularProgressIndicator), findsNothing);
        },
      );
    });
  });
}

class _TesterWidget extends StatelessWidget {
  const _TesterWidget(
    this.coffeeBloc,
    this.favouriteCoffeeBloc,
  );
  final CoffeeBloc coffeeBloc;
  final FavouriteCoffeeBloc favouriteCoffeeBloc;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavouriteCoffeeBloc>.value(
      value: favouriteCoffeeBloc,
      child: BlocProvider<CoffeeBloc>.value(
        value: coffeeBloc,
        child: const CoffeePage(),
      ),
    );
  }
}
