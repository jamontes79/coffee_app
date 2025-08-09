import 'package:coffee_app/app/app.dart';
import 'package:coffee_app/coffee/application/favourite/favourite_coffee_bloc.dart';
import 'package:coffee_app/coffee/application/single/coffee_bloc.dart';
import 'package:coffee_app/coffee/presentation/coffee_page.dart';
import 'package:coffee_app/injection/injection.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_mock/application/mocked_coffee_bloc.dart';
import '../../_mock/application/mocked_favourite_coffee_bloc.dart';

void main() {
  late MockedCoffeeBloc mockedCoffeeBloc;
  late MockedFavouriteCoffeeBloc mockedFavouriteCoffeeBloc;
  setUp(() {
    mockedCoffeeBloc = MockedCoffeeBloc()..mockState(CoffeeState.initial());
    mockedFavouriteCoffeeBloc = MockedFavouriteCoffeeBloc()
      ..mockState(
        const FavouriteCoffeeState(
          status: FavouriteCoffeeStatus.initial,
          favouriteCoffees: [],
        ),
      );

    getIt
      ..registerSingleton<CoffeeBloc>(mockedCoffeeBloc)
      ..registerSingleton<FavouriteCoffeeBloc>(mockedFavouriteCoffeeBloc);
  });

  tearDown(getIt.reset);

  group('App', () {
    testWidgets('renders CoffeeMainWidget', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(CoffeePage), findsOneWidget);
    });
  });
}
