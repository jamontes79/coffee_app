import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app/theme/application/theme_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../_mock/third_party/mocked_storage.dart';

void main() {
  late ThemeBloc themeBloc;
  late MockedStorage mockedStorage;
  setUp(() {
    mockedStorage = MockedStorage()..mockWrite();
    HydratedBloc.storage = mockedStorage;
    themeBloc = ThemeBloc();
  });

  group(ThemeBloc, () {
    test('initial state is ThemeLight', () {
      expect(themeBloc.state, const ThemeLight());
    });

    group(ToggleThemeEvent, () {
      blocTest(
        'Should emit ThemeDark when ToggleThemeEvent '
        'and current state is ThemeLight',
        build: () {
          return themeBloc;
        },
        act: (bloc) => bloc.add(const ToggleThemeEvent()),
        expect: () => [const ThemeDark()],
      );

      blocTest(
        'Should emit ThemeLight when ToggleThemeEvent '
        'and current state is ThemeDark',
        build: () {
          return themeBloc;
        },
        seed: () => const ThemeDark(),
        act: (bloc) => bloc.add(const ToggleThemeEvent()),
        expect: () => [const ThemeLight()],
      );
    });

    group('fromJson', () {
      test('Should return ThemeLight when json is {"theme": "light"}', () {
        final json = {'theme': 'light'};
        final state = themeBloc.fromJson(json);
        expect(state, const ThemeLight());
      });

      test('Should return ThemeDark when json is {"theme": "dark"}', () {
        final json = {'theme': 'dark'};
        final state = themeBloc.fromJson(json);
        expect(state, const ThemeDark());
      });

      test('Should return null when json is empty', () {
        final json = <String, dynamic>{};
        final state = themeBloc.fromJson(json);
        expect(state, isNull);
      });
    });

    group(ThemeEvent, () {
      test('ToggleThemeEvent should be comparable', () {
        const event1 = ToggleThemeEvent();
        const event2 = ToggleThemeEvent();

        expect(event1 == event2, isTrue);
        expect(event1.props, <Object?>[]);
      });
    });
  });
}
