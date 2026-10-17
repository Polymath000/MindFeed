import 'package:flutter/material.dart';

class EditorialNewsItem {
  final String id;
  final String badge;
  final Color badgeColor;
  final String title;
  final String updated;
  final String authorName;
  final String authorRole;
  final String authorAvatar;
  final String excerpt;
  final Color color;
  final bool isLive;
  final String? categoryId;
  final String? categorySlug;
  final List<String> tags;
  final String? content;
  final String? coverImageUrl;
  final String? authorId;
  final DateTime? publishedAt;
  final int readingTimeMinutes;
  final String status;
  int starCount;
  bool isStarred;
  bool isLiked;
  bool isSaved;
  int likesCount;
  double authorRatingAvg;
  int authorRatingCount;
  int userAuthorStars;

  EditorialNewsItem({
    required this.id,
    required this.badge,
    required this.badgeColor,
    required this.title,
    required this.updated,
    required this.authorName,
    required this.authorRole,
    required this.authorAvatar,
    required this.excerpt,
    required this.color,
    this.isLive = false,
    this.categoryId,
    this.categorySlug,
    this.tags = const [],
    this.content,
    this.coverImageUrl,
    this.authorId,
    this.publishedAt,
    this.readingTimeMinutes = 3,
    this.status = 'published',
    this.starCount = 0,
    this.isStarred = false,
    this.isLiked = false,
    this.isSaved = false,
    this.likesCount = 0,
    this.authorRatingAvg = 0.0,
    this.authorRatingCount = 0,
    this.userAuthorStars = 0,
  });

  String get authorKey => (authorId != null && authorId!.trim().isNotEmpty)
      ? authorId!.trim()
      : authorName.trim().toLowerCase();

  bool get isEditableWithinWindow {
    if (status != 'published') return true;
    final published = publishedAt;
    if (published == null) return false;
    return DateTime.now().toUtc().difference(published.toUtc()) <=
        const Duration(days: 30);
  }
}
