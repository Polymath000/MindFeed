part of 'categories_cubit.dart';

sealed class CategoriesState {
  final List<String> selectedCategories;
  const CategoriesState(this.selectedCategories);
}

final class CategoriesInitial extends CategoriesState {
  const CategoriesInitial(super.selectedCategories);
}

final class CategoriesSelectionChanged extends CategoriesState {
  const CategoriesSelectionChanged(super.selectedCategories);
}

final class CategoriesLoading extends CategoriesState {
  const CategoriesLoading(super.selectedCategories);
}

final class CategoriesSuccess extends CategoriesState {
  final bool isPendingSync;
  final bool isRemoteSynced;

  const CategoriesSuccess(
    super.selectedCategories, {
    this.isPendingSync = false,
    this.isRemoteSynced = true,
  });
}

final class CategoriesFailure extends CategoriesState {
  final String errorMessage;
  const CategoriesFailure({
    required this.errorMessage,
    required List<String> selectedCategories,
  }) : super(selectedCategories);
}

