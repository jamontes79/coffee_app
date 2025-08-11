import 'package:coffee_app/app/app.dart';
import 'package:coffee_app/coffee/application/favourite/favourite_coffee_bloc.dart';
import 'package:coffee_app/coffee/application/single/coffee_bloc.dart';
import 'package:coffee_app/coffee/presentation/coffee_page.dart';
import 'package:coffee_app/injection/injection.dart';
import 'package:coffee_app/theme/application/theme_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../_mock/application/mocked_coffee_bloc.dart';
import '../../_mock/application/mocked_favourite_coffee_bloc.dart';
import '../../_mock/application/mocked_theme_bloc.dart';
import '../../_mock/third_party/mocked_storage.dart';

void main() {
  late MockedCoffeeBloc mockedCoffeeBloc;
  late MockedFavouriteCoffeeBloc mockedFavouriteCoffeeBloc;
  late MockedThemeBloc mockedThemeBloc;
  late MockedStorage mockedStorage;

  setUp(() {
    mockedCoffeeBloc = MockedCoffeeBloc()
      ..mockState(const CoffeeInitialState());
    mockedFavouriteCoffeeBloc = MockedFavouriteCoffeeBloc()
      ..mockState(
        const FavouriteCoffeeState(
          status: FavouriteCoffeeStatus.initial,
          favouriteCoffees: [],
        ),
      );
    mockedStorage = MockedStorage()..mockWrite();
    mockedThemeBloc = MockedThemeBloc()..mockState(const ThemeLight());
    HydratedBloc.storage = mockedStorage;

    getIt
      ..registerSingleton<CoffeeBloc>(mockedCoffeeBloc)
      ..registerSingleton<FavouriteCoffeeBloc>(mockedFavouriteCoffeeBloc)
      ..registerSingleton<ThemeBloc>(mockedThemeBloc);
  });

  tearDown(getIt.reset);

  group('App', () {
    testWidgets('renders CoffeeMainWidget', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(CoffeePage), findsOneWidget);
    });
  });
}
