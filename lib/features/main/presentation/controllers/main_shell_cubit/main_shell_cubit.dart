import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/features/profile/domain/usecases/reconcile_category_sync_use_case.dart';

part 'main_shell_state.dart';

class MainShellCubit extends Cubit<MainShellState> {
  final ReconcileCategorySyncUseCase _reconcileCategorySyncUseCase;

  MainShellCubit({
    required ReconcileCategorySyncUseCase reconcileCategorySyncUseCase,
  })  : _reconcileCategorySyncUseCase = reconcileCategorySyncUseCase,
        super(const MainShellInitial());

  Future<void> onShellStarted({String? userId}) async {
    emit(const MainShellReconciling());
    final result = await _reconcileCategorySyncUseCase(userId: userId);
    if (!isClosed) {
      emit(MainShellReady(didReconcile: result));
    }
  }
}
