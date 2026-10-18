import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/features/main/presentation/controllers/main_shell_cubit/main_shell_cubit.dart';
import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';
import 'package:mind_feed/features/profile/domain/usecases/reconcile_category_sync_use_case.dart';

class FakeProfileRepository extends Fake implements ProfileRepository {
  bool returnValue = false;
  String? capturedUserId;

  @override
  Future<bool> reconcilePendingCategorySync({String? userId}) async {
    capturedUserId = userId;
    return returnValue;
  }
}

void main() {
  late FakeProfileRepository fakeRepo;
  late ReconcileCategorySyncUseCase useCase;
  late MainShellCubit cubit;

  setUp(() {
    fakeRepo = FakeProfileRepository();
    useCase = ReconcileCategorySyncUseCase(fakeRepo);
    cubit = MainShellCubit(reconcileCategorySyncUseCase: useCase);
  });

  tearDown(() async {
    await cubit.close();
  });

  group('MainShellCubit', () {
    test('initial state is MainShellInitial', () {
      expect(cubit.state, isA<MainShellInitial>());
    });

    test('onShellStarted emits MainShellReconciling then MainShellReady(didReconcile: true)', () async {
      fakeRepo.returnValue = true;

      expectLater(
        cubit.stream,
        emitsInOrder([
          isA<MainShellReconciling>(),
          isA<MainShellReady>().having((s) => s.didReconcile, 'didReconcile', isTrue),
        ]),
      );

      await cubit.onShellStarted(userId: 'user-777');
      expect(fakeRepo.capturedUserId, equals('user-777'));
    });

    test('onShellStarted emits MainShellReady(didReconcile: false) when no reconciliation needed', () async {
      fakeRepo.returnValue = false;

      expectLater(
        cubit.stream,
        emitsInOrder([
          isA<MainShellReconciling>(),
          isA<MainShellReady>().having((s) => s.didReconcile, 'didReconcile', isFalse),
        ]),
      );

      await cubit.onShellStarted();
    });
  });
}
