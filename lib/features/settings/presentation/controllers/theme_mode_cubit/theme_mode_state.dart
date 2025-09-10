part of 'theme_mode_cubit.dart';

@immutable
sealed class ThemeModeState {
  const ThemeModeState();
}

final class ThemeModeInitial extends ThemeModeState {
  const ThemeModeInitial();
}

final class ThemeModeDark extends ThemeModeState {
  const ThemeModeDark();
}

final class ThemeModeLight extends ThemeModeState {
  const ThemeModeLight();
}

final class ThemeModeSystem extends ThemeModeState {
  const ThemeModeSystem();
}
