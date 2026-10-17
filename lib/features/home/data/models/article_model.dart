import 'package:mind_feed/features/home/domain/entities/article_entity.dart';

class ArticleModel extends ArticleEntity {
  const ArticleModel({
    required super.id,
    super.legacyId,
    required super.title,
    required super.slug,
    required super.excerpt,
    super.content,
    super.authorName = 'Editorial Staff',
    super.authorRole = 'Writer',
    super.authorAvatar,
    super.authorId,
    super.categoryId,
    super.categorySlug,
    super.badge = 'NEWS',
    super.badgeColor = '#FFF1C6',
    super.cardColor = '#FFF1C6',
    super.isLive = false,
    super.heroImageUrl,
    super.coverImageUrl,
    super.likesCount = 0,
    super.savesCount = 0,
    super.starCount = 0,
    super.authorRatingAvg = 0.0,
    super.authorRatingCount = 0,
    super.userAuthorStars = 0,
    super.readingTimeMinutes = 3,
    super.status = 'draft',
    super.tags = const [],
    super.publishedAt,
    super.createdAt,
    super.updatedAt,
    super.isLiked = false,
    super.isSaved = false,
    super.isStarred = false,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] as String? ?? '',
      legacyId: json['legacy_id'] as String?,
      title: json['title'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      excerpt: json['excerpt'] as String? ?? '',
      content: json['content'] as String?,
      authorName: json['author_name'] as String? ?? 'Editorial Staff',
      authorRole: json['author_role'] as String? ?? 'Writer',
      authorAvatar: json['author_avatar'] as String?,
      authorId: json['author_id'] as String?,
      categoryId: json['category_id'] as String?,
      categorySlug: json['category_slug'] as String?,
      badge: json['badge'] as String? ?? 'NEWS',
      badgeColor: json['badge_color'] as String? ?? '#FFF1C6',
      cardColor: json['card_color'] as String? ?? '#FFF1C6',
      isLive: json['is_live'] as bool? ?? false,
      heroImageUrl: json['hero_image_url'] as String?,
      coverImageUrl: json['cover_image_url'] as String?,
      likesCount: (json['likes_count'] as num?)?.toInt() ?? 0,
      savesCount: (json['saves_count'] as num?)?.toInt() ?? 0,
      starCount: (json['star_count'] as num?)?.toInt() ?? 0,
      authorRatingAvg: (json['author_rating_avg'] as num?)?.toDouble() ?? 0.0,
      authorRatingCount: (json['author_rating_count'] as num?)?.toInt() ?? 0,
      userAuthorStars: (json['user_author_stars'] as num?)?.toInt() ?? 0,
      readingTimeMinutes: (json['reading_time_minutes'] as num?)?.toInt() ?? 3,
      status: json['status'] as String? ?? 'draft',
      tags: _parseTags(json['tags']),
      publishedAt: _parseDateTime(json['published_at']),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
      isLiked: json['is_liked'] as bool? ?? false,
      isSaved: json['is_saved'] as bool? ?? false,
      isStarred: json['is_starred'] as bool? ?? false,
    );
  }

  factory ArticleModel.fromEntity(ArticleEntity entity) {
    return ArticleModel(
      id: entity.id,
      legacyId: entity.legacyId,
      title: entity.title,
      slug: entity.slug,
      excerpt: entity.excerpt,
      content: entity.content,
      authorName: entity.authorName,
      authorRole: entity.authorRole,
      authorAvatar: entity.authorAvatar,
      authorId: entity.authorId,
      categoryId: entity.categoryId,
      categorySlug: entity.categorySlug,
      badge: entity.badge,
      badgeColor: entity.badgeColor,
      cardColor: entity.cardColor,
      isLive: entity.isLive,
      heroImageUrl: entity.heroImageUrl,
      coverImageUrl: entity.coverImageUrl,
      likesCount: entity.likesCount,
      savesCount: entity.savesCount,
      starCount: entity.starCount,
      authorRatingAvg: entity.authorRatingAvg,
      authorRatingCount: entity.authorRatingCount,
      userAuthorStars: entity.userAuthorStars,
      readingTimeMinutes: entity.readingTimeMinutes,
      status: entity.status,
      tags: entity.tags,
      publishedAt: entity.publishedAt,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isLiked: entity.isLiked,
      isSaved: entity.isSaved,
      isStarred: entity.isStarred,
    );
  }

  Map<String, dynamic> toJson({bool includeServerManagedFields = false}) {
    final map = <String, dynamic>{
      'title': title,
      'slug': slug,
      'excerpt': excerpt,
      'author_name': authorName,
      'author_role': authorRole,
      'badge': badge,
      'badge_color': badgeColor,
      'card_color': cardColor,
      'is_live': isLive,
      'reading_time_minutes': readingTimeMinutes,
      'status': status,
      'tags': tags,
    };

    if (id.isNotEmpty) map['id'] = id;
    if (legacyId != null) map['legacy_id'] = legacyId;
    if (content != null) map['content'] = content;
    if (authorAvatar != null) map['author_avatar'] = authorAvatar;
    if (authorId != null) map['author_id'] = authorId;
    if (categoryId != null) map['category_id'] = categoryId;
    if (categorySlug != null) map['category_slug'] = categorySlug;
    if (heroImageUrl != null) map['hero_image_url'] = heroImageUrl;
    if (coverImageUrl != null) map['cover_image_url'] = coverImageUrl;

    if (includeServerManagedFields) {
      map['likes_count'] = likesCount;
      map['saves_count'] = savesCount;
      map['star_count'] = starCount;
      map['author_rating_avg'] = authorRatingAvg;
      map['author_rating_count'] = authorRatingCount;
      if (publishedAt != null) map['published_at'] = publishedAt!.toIso8601String();
      if (createdAt != null) map['created_at'] = createdAt!.toIso8601String();
      if (updatedAt != null) map['updated_at'] = updatedAt!.toIso8601String();
    }

    return map;
  }

  @override
  ArticleModel copyWith({
    String? id,
    String? legacyId,
    String? title,
    String? slug,
    String? excerpt,
    String? content,
    String? authorName,
    String? authorRole,
    String? authorAvatar,
    String? authorId,
    String? categoryId,
    String? categorySlug,
    String? badge,
    String? badgeColor,
    String? cardColor,
    bool? isLive,
    String? heroImageUrl,
    String? coverImageUrl,
    int? likesCount,
    int? savesCount,
    int? starCount,
    double? authorRatingAvg,
    int? authorRatingCount,
    int? userAuthorStars,
    int? readingTimeMinutes,
    String? status,
    List<String>? tags,
    DateTime? publishedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isLiked,
    bool? isSaved,
    bool? isStarred,
  }) {
    return ArticleModel(
      id: id ?? this.id,
      legacyId: legacyId ?? this.legacyId,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      excerpt: excerpt ?? this.excerpt,
      content: content ?? this.content,
      authorName: authorName ?? this.authorName,
      authorRole: authorRole ?? this.authorRole,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      authorId: authorId ?? this.authorId,
      categoryId: categoryId ?? this.categoryId,
      categorySlug: categorySlug ?? this.categorySlug,
      badge: badge ?? this.badge,
      badgeColor: badgeColor ?? this.badgeColor,
      cardColor: cardColor ?? this.cardColor,
      isLive: isLive ?? this.isLive,
      heroImageUrl: heroImageUrl ?? this.heroImageUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      likesCount: likesCount ?? this.likesCount,
      savesCount: savesCount ?? this.savesCount,
      starCount: starCount ?? this.starCount,
      authorRatingAvg: authorRatingAvg ?? this.authorRatingAvg,
      authorRatingCount: authorRatingCount ?? this.authorRatingCount,
      userAuthorStars: userAuthorStars ?? this.userAuthorStars,
      readingTimeMinutes: readingTimeMinutes ?? this.readingTimeMinutes,
      status: status ?? this.status,
      tags: tags ?? this.tags,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      isStarred: isStarred ?? this.isStarred,
    );
  }

  static List<String> _parseTags(dynamic rawTags) {
    if (rawTags == null) return const [];
    if (rawTags is List) {
      return rawTags.map((e) => e.toString()).toList();
    }
    if (rawTags is String) {
      final cleaned = rawTags.replaceAll(RegExp(r'^\{|\}$'), '');
      if (cleaned.trim().isEmpty) return const [];
      return cleaned
          .split(',')
          .map((e) => e.replaceAll('"', '').trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    return const [];
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}
