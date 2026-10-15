part of 'categories_cubit.dart';

abstract class CategoriesState {
  final List<String> selectedCategories;
  const CategoriesState(this.selectedCategories);
}

class CategoriesInitial extends CategoriesState {
  const CategoriesInitial(super.selectedCategories);
}

class CategoriesSelectionChanged extends CategoriesState {
  const CategoriesSelectionChanged(super.selectedCategories);
}

class CategoriesLoading extends CategoriesState {
  const CategoriesLoading(super.selectedCategories);
}

class CategoriesSuccess extends CategoriesState {
  final bool isPendingSync;
  final bool isRemoteSynced;

  const CategoriesSuccess(
    super.selectedCategories, {
    this.isPendingSync = false,
    this.isRemoteSynced = true,
  });
}

class CategoriesFailure extends CategoriesState {
  final String errorMessage;
  const CategoriesFailure({
    required this.errorMessage,
    required List<String> selectedCategories,
  }) : super(selectedCategories);
}
