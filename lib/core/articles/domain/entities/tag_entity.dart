import 'package:equatable/equatable.dart';

class TagEntity extends Equatable {
  final String id;
  final String name;
  final String slug;

  const TagEntity({
    required this.id,
    required this.name,
    required this.slug,
  });

  @override
  List<Object?> get props => [id, name, slug];
}
