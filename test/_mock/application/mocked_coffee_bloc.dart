import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app/coffee/application/single/coffee_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockedCoffeeBloc extends MockBloc<CoffeeEvent, CoffeeState>
    implements CoffeeBloc {
  void mockState(CoffeeState expected) {
    when(() => state).thenReturn(expected);
  }
}
