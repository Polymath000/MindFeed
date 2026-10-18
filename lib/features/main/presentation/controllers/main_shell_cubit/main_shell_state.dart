part of 'main_shell_cubit.dart';

sealed class MainShellState {
  const MainShellState();
}

final class MainShellInitial extends MainShellState {
  const MainShellInitial();
}

final class MainShellReconciling extends MainShellState {
  const MainShellReconciling();
}

final class MainShellReady extends MainShellState {
  final bool didReconcile;
  const MainShellReady({this.didReconcile = false});
}
