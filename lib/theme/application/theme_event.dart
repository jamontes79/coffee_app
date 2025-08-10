part of 'theme_bloc.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();
}

final class ToggleThemeEvent extends ThemeEvent {
  const ToggleThemeEvent();

  @override
  List<Object?> get props => [];
}
