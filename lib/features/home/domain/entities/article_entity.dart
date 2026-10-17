import 'package:equatable/equatable.dart';

class ArticleEntity extends Equatable {
  final String id;
  final String? legacyId;
  final String title;
  final String slug;
  final String excerpt;
  final String? content;
  final String authorName;
  final String authorRole;
  final String? authorAvatar;
  final String? authorId;
  final String? categoryId;
  final String? categorySlug;
  final String badge;
  final String badgeColor;
  final String cardColor;
  final bool isLive;
  final String? heroImageUrl;
  final String? coverImageUrl;
  final int likesCount;
  final int savesCount;
  final int starCount;
  final double authorRatingAvg;
  final int authorRatingCount;
  final int userAuthorStars;
  final int readingTimeMinutes;
  final String status;
  final List<String> tags;
  final DateTime? publishedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isLiked;
  final bool isSaved;
  final bool isStarred;

  const ArticleEntity({
    required this.id,
    this.legacyId,
    required this.title,
    required this.slug,
    required this.excerpt,
    this.content,
    this.authorName = 'Editorial Staff',
    this.authorRole = 'Writer',
    this.authorAvatar,
    this.authorId,
    this.categoryId,
    this.categorySlug,
    this.badge = 'NEWS',
    this.badgeColor = '#FFF1C6',
    this.cardColor = '#FFF1C6',
    this.isLive = false,
    this.heroImageUrl,
    this.coverImageUrl,
    this.likesCount = 0,
    this.savesCount = 0,
    this.starCount = 0,
    this.authorRatingAvg = 0.0,
    this.authorRatingCount = 0,
    this.userAuthorStars = 0,
    this.readingTimeMinutes = 3,
    this.status = 'draft',
    this.tags = const [],
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
    this.isLiked = false,
    this.isSaved = false,
    this.isStarred = false,
  });

  ArticleEntity copyWith({
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
    return ArticleEntity(
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

  @override
  List<Object?> get props => [
        id,
        legacyId,
        title,
        slug,
        excerpt,
        content,
        authorName,
        authorRole,
        authorAvatar,
        authorId,
        categoryId,
        categorySlug,
        badge,
        badgeColor,
        cardColor,
        isLive,
        heroImageUrl,
        coverImageUrl,
        likesCount,
        savesCount,
        starCount,
        authorRatingAvg,
        authorRatingCount,
        userAuthorStars,
        readingTimeMinutes,
        status,
        tags,
        publishedAt,
        createdAt,
        updatedAt,
        isLiked,
        isSaved,
        isStarred,
      ];
}
