import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';
import 'package:mind_feed/features/profile/domain/usecases/save_favorite_categories_use_case.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final SaveFavoriteCategoriesUseCase saveFavoriteCategoriesUseCase;
  final Set<String> _selectedCategories = <String>{};

  CategoriesCubit({
    required this.saveFavoriteCategoriesUseCase,
    List<String>? initialCategories,
  }) : super(CategoriesInitial(initialCategories ?? const [])) {
    if (initialCategories != null) {
      _selectedCategories.addAll(initialCategories);
    }
  }

  Set<String> get selectedCategories => Set.unmodifiable(_selectedCategories);

  void toggleCategory(String name) {
    if (_selectedCategories.contains(name)) {
      _selectedCategories.remove(name);
    } else {
      _selectedCategories.add(name);
    }
    emit(CategoriesSelectionChanged(_selectedCategories.toList()));
  }

  Future<void> saveCategories({
    required String? userId,
    UserEntity? currentUser,
  }) async {
    if (state is CategoriesLoading) return;
    emit(CategoriesLoading(_selectedCategories.toList()));

    final list = _selectedCategories.toList();
    final effectiveUserId = userId ?? currentUser?.email ?? 'anonymous';

    final outcome = await saveFavoriteCategoriesUseCase(
      userId: effectiveUserId,
      categoryNames: list,
      currentUser: currentUser,
    );

    if (!outcome.isLocalSaved) {
      emit(CategoriesFailure(
        errorMessage: outcome.errorMessage ?? 'Failed to save categories locally',
        selectedCategories: list,
      ));
      return;
    }

    emit(CategoriesSuccess(
      list,
      isPendingSync: outcome.isPendingSync,
      isRemoteSynced: outcome.isRemoteSynced,
    ));
  }
}
