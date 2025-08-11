import 'package:coffee_app/coffee/application/favourite/favourite_coffee_bloc.dart';
import 'package:coffee_app/coffee/application/single/coffee_bloc.dart';
import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:coffee_app/coffee/presentation/coffee_page.dart';
import 'package:coffee_app/coffee/presentation/widgets/coffee_error_widget.dart';
import 'package:coffee_app/coffee/presentation/widgets/coffee_individual_widget.dart';
import 'package:coffee_app/routes/routes.dart';
import 'package:coffee_app/theme/application/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../_mock/application/mocked_coffee_bloc.dart';
import '../../_mock/application/mocked_favourite_coffee_bloc.dart';
import '../../_mock/application/mocked_theme_bloc.dart';
import '../../helpers/helpers.dart';
import '../../helpers/mock_go_router_provider.dart';

void main() {
  late MockGoRouter mockGoRouter;
  late MockedCoffeeBloc mockedCoffeeBloc;
  late MockedFavouriteCoffeeBloc mockedFavouriteCoffeeBloc;
  late MockedThemeBloc mockedThemeBloc;

  const coffee = Coffee(url: 'https://example.com/coffee.jpg');

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
    mockedThemeBloc = MockedThemeBloc()..mockState(const ThemeLight());
  });

  group(CoffeePage, () {
    group('Menu', () {
      testWidgets(
        'should display a popup menu with "Favourite Coffees" option',
        (tester) async {
          mockedCoffeeBloc.mockState(const CoffeeLoadedState(coffee));
          await tester.pumpApp(
            _TesterWidget(
              mockedCoffeeBloc,
              mockedFavouriteCoffeeBloc,
              mockedThemeBloc,
            ),
          );

          await tester.pumpAndSettle();

          await tester.tap(find.byType(PopupMenuButton<String>));
          await tester.pumpAndSettle();
          expect(find.byType(PopupMenuItem<String>), findsNWidgets(2));

          expect(find.text('Favourite Coffees'), findsOneWidget);
          expect(find.text('Switch Theme Mode'), findsOneWidget);
        },
      );

      testWidgets(
        'should navigate to "Favourite Coffees" page when selected',
        (tester) async {
          mockedCoffeeBloc.mockState(const CoffeeLoadedState(coffee));
          await tester.pumpApp(
            MockGoRouterProvider(
              goRouter: mockGoRouter,
              child: _TesterWidget(
                mockedCoffeeBloc,
                mockedFavouriteCoffeeBloc,
                mockedThemeBloc,
              ),
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

      testWidgets(
        'should call ToggleThemeEvent when "Switch Theme Mode" selected',
        (tester) async {
          mockedCoffeeBloc.mockState(const CoffeeLoadedState(coffee));
          await tester.pumpApp(
            MockGoRouterProvider(
              goRouter: mockGoRouter,
              child: _TesterWidget(
                mockedCoffeeBloc,
                mockedFavouriteCoffeeBloc,
                mockedThemeBloc,
              ),
            ),
          );

          await tester.pumpAndSettle();

          await tester.tap(find.byType(PopupMenuButton<String>));
          await tester.pumpAndSettle();

          await tester.tap(find.text('Switch Theme Mode'));
          await tester.pumpAndSettle();

          verify(
            () => mockedThemeBloc.add(const ToggleThemeEvent()),
          ).called(1);
        },
      );
    });
    group('Loading', () {
      testWidgets(
        'should render CircularProgressIndicator when bloc state is loading',
        (tester) async {
          mockedCoffeeBloc.mockState(const CoffeeLoadingState());
          await tester.pumpApp(
            _TesterWidget(
              mockedCoffeeBloc,
              mockedFavouriteCoffeeBloc,
              mockedThemeBloc,
            ),
          );

          final placeholderFinder = find.byType(CircularProgressIndicator);

          expect(placeholderFinder, findsOneWidget);
        },
      );

      testWidgets(
        'should render CircularProgressIndicator when bloc state is initial',
        (tester) async {
          mockedCoffeeBloc.mockState(const CoffeeInitialState());
          await tester.pumpApp(
            _TesterWidget(
              mockedCoffeeBloc,
              mockedFavouriteCoffeeBloc,
              mockedThemeBloc,
            ),
          );

          expect(find.byType(CircularProgressIndicator), findsOneWidget);
          expect(find.byType(CoffeeErrorWidget), findsNothing);
          expect(find.byType(CoffeeIndividualWidget), findsNothing);
        },
      );
    });

    group('Error', () {
      testWidgets(
        'should render CoffeeErrorWidget when bloc state is error',
        (tester) async {
          mockedCoffeeBloc.mockState(const CoffeeErrorState());
          await tester.pumpApp(
            _TesterWidget(
              mockedCoffeeBloc,
              mockedFavouriteCoffeeBloc,
              mockedThemeBloc,
            ),
          );

          expect(find.byType(CoffeeErrorWidget), findsOneWidget);
          expect(find.byType(CoffeeIndividualWidget), findsNothing);
          expect(find.byType(CircularProgressIndicator), findsNothing);
        },
      );
    });

    group('Loaded', () {
      testWidgets(
        'should render CoffeeIndividualWidget when bloc state is loaded',
        (tester) async {
          mockedCoffeeBloc.mockState(const CoffeeLoadedState(coffee));
          await tester.pumpApp(
            _TesterWidget(
              mockedCoffeeBloc,
              mockedFavouriteCoffeeBloc,
              mockedThemeBloc,
            ),
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
    this.themeBloc,
  );
  final CoffeeBloc coffeeBloc;
  final FavouriteCoffeeBloc favouriteCoffeeBloc;
  final ThemeBloc themeBloc;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FavouriteCoffeeBloc>.value(value: favouriteCoffeeBloc),
        BlocProvider<CoffeeBloc>.value(value: coffeeBloc),
        BlocProvider<ThemeBloc>.value(value: themeBloc),
      ],
      child: const CoffeePage(),
    );
  }
}
