import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String? description;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
  });

  @override
  List<Object?> get props => [id, name, slug, description];
}
