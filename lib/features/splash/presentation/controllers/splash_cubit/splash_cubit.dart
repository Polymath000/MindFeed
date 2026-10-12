import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/startup_destination.dart';
import '../../../domain/usecases/check_app_startup_use_case.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final CheckAppStartupUseCase _checkAppStartupUseCase;
  final Duration _minDisplayDuration;

  SplashCubit({
    required CheckAppStartupUseCase checkAppStartupUseCase,
    Duration minDisplayDuration = const Duration(milliseconds: 1800),
  })  : _checkAppStartupUseCase = checkAppStartupUseCase,
        _minDisplayDuration = minDisplayDuration,
        super(const SplashInitial());

  Future<void> initApp() async {
    final stopwatch = Stopwatch()..start();
    final destination = await _checkAppStartupUseCase();
    final elapsed = stopwatch.elapsedMilliseconds;
    final remaining = _minDisplayDuration.inMilliseconds - elapsed;

    if (remaining > 0) {
      await Future<void>.delayed(Duration(milliseconds: remaining));
    }

    if (isClosed) return;

    switch (destination) {
      case StartupOnboarding():
        emit(const SplashNavigateToOnboarding());
      case StartupLogin():
        emit(const SplashNavigateToLogin());
      case StartupMain():
        emit(const SplashNavigateToMain());
    }
  }
}
