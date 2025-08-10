import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app/theme/application/theme_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockedThemeBloc extends MockBloc<ThemeEvent, ThemeState>
    implements ThemeBloc {
  void mockState(ThemeState expected) {
    when(() => state).thenReturn(expected);
  }
}
