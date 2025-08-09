import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app/coffee/application/favourite/favourite_coffee_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockedFavouriteCoffeeBloc
    extends MockBloc<FavouriteCoffeeEvent, FavouriteCoffeeState>
    implements FavouriteCoffeeBloc {
  void mockState(FavouriteCoffeeState expected) {
    when(() => state).thenReturn(expected);
  }

  void mockListen(List<FavouriteCoffeeState> states) {
    whenListen(
      this,
      Stream<FavouriteCoffeeState>.fromIterable(states),
    );
  }
}
