import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

part 'theme_event.dart';
part 'theme_state.dart';

@injectable
class ThemeBloc extends HydratedBloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeLight()) {
    on<ToggleThemeEvent>(_onToggleTheme);
  }
  FutureOr<void> _onToggleTheme(
    ToggleThemeEvent event,
    Emitter<ThemeState> emit,
  ) {
    if (state is ThemeLight) {
      emit(const ThemeDark());
    } else if (state is ThemeDark) {
      emit(const ThemeLight());
    }
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    final theme = json['theme'] as String?;
    if (theme == 'light') {
      return const ThemeLight();
    } else if (theme == 'dark') {
      return const ThemeDark();
    }
    return null;
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    if (state is ThemeLight) {
      return {'theme': 'light'};
    } else if (state is ThemeDark) {
      return {'theme': 'dark'};
    }
    return null;
  }
}
