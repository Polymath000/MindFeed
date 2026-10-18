import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';
import 'package:mind_feed/features/profile/domain/usecases/reconcile_category_sync_use_case.dart';

class FakeProfileRepository extends Fake implements ProfileRepository {
  String? lastReconciledUserId;
  bool shouldReturn = true;

  @override
  Future<bool> reconcilePendingCategorySync({String? userId}) async {
    lastReconciledUserId = userId;
    return shouldReturn;
  }
}

void main() {
  late FakeProfileRepository fakeRepo;
  late ReconcileCategorySyncUseCase useCase;

  setUp(() {
    fakeRepo = FakeProfileRepository();
    useCase = ReconcileCategorySyncUseCase(fakeRepo);
  });

  group('ReconcileCategorySyncUseCase', () {
    test('delegates reconcilePendingCategorySync to ProfileRepository', () async {
      fakeRepo.shouldReturn = true;

      final result = await useCase(userId: 'test-user-id');

      expect(result, isTrue);
      expect(fakeRepo.lastReconciledUserId, equals('test-user-id'));
    });

    test('returns false when no sync is needed or reconciliation fails', () async {
      fakeRepo.shouldReturn = false;

      final result = await useCase();

      expect(result, isFalse);
      expect(fakeRepo.lastReconciledUserId, isNull);
    });
  });
}
