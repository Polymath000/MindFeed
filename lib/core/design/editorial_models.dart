import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:mind_feed/core/articles/domain/entities/article_entity.dart';
import 'package:mind_feed/core/articles/domain/entities/downloaded_article_entity.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/services/supabase_storage_service.dart';

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
  String? get heroImageUrl => coverImageUrl;
  final Uint8List? coverImageBytes;
  final Uint8List? authorAvatarBytes;
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
    this.coverImageBytes,
    this.authorAvatarBytes,
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

  EditorialNewsItem copyWith({
    bool? isSaved,
    bool? isLiked,
    bool? isStarred,
    int? likesCount,
    int? starCount,
    String? content,
    String? coverImageUrl,
    Uint8List? coverImageBytes,
    Uint8List? authorAvatarBytes,
    String? authorAvatar,
    double? authorRatingAvg,
    int? authorRatingCount,
    int? userAuthorStars,
  }) {
    return EditorialNewsItem(
      id: id,
      badge: badge,
      badgeColor: badgeColor,
      title: title,
      updated: updated,
      authorName: authorName,
      authorRole: authorRole,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      excerpt: excerpt,
      color: color,
      isLive: isLive,
      categoryId: categoryId,
      categorySlug: categorySlug,
      tags: tags,
      content: content ?? this.content,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      coverImageBytes: coverImageBytes ?? this.coverImageBytes,
      authorAvatarBytes: authorAvatarBytes ?? this.authorAvatarBytes,
      authorId: authorId,
      publishedAt: publishedAt,
      readingTimeMinutes: readingTimeMinutes,
      status: status,
      starCount: starCount ?? this.starCount,
      isStarred: isStarred ?? this.isStarred,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      likesCount: likesCount ?? this.likesCount,
      authorRatingAvg: authorRatingAvg ?? this.authorRatingAvg,
      authorRatingCount: authorRatingCount ?? this.authorRatingCount,
      userAuthorStars: userAuthorStars ?? this.userAuthorStars,
    );
  }
}

extension ArticleEntityEditorialMapper on ArticleEntity {
  EditorialNewsItem toEditorialNewsItem() {
    return EditorialNewsItem(
      id: id,
      badge: badge,
      badgeColor: _parseHexColor(
        badgeColor,
        defaultColor: AppColors.redHighlight,
      ),
      title: title,
      updated: _formatUpdatedTime(publishedAt ?? updatedAt),
      authorName: authorName,
      authorRole: authorRole,
      authorAvatar: SupabaseStorageService.resolveAvatarUrl(authorAvatar) ?? '',
      excerpt: excerpt,
      color: _parseHexColor(cardColor, defaultColor: AppColors.cream),
      isLive: isLive,
      categoryId: categoryId,
      categorySlug: categorySlug,
      tags: tags,
      content: content,
      coverImageUrl: SupabaseStorageService.resolveArticleMediaUrl(
        (heroImageUrl != null && heroImageUrl!.trim().isNotEmpty)
            ? heroImageUrl
            : coverImageUrl,
      ),
      authorId: authorId,
      publishedAt: publishedAt,
      readingTimeMinutes: readingTimeMinutes,
      status: status,
      starCount: starCount,
      isStarred: isStarred,
      isLiked: isLiked,
      isSaved: isSaved,
      likesCount: likesCount,
      authorRatingAvg: authorRatingAvg,
      authorRatingCount: authorRatingCount,
      userAuthorStars: userAuthorStars,
    );
  }

  static Color _parseHexColor(String? hexString, {required Color defaultColor}) {
    if (hexString == null || hexString.trim().isEmpty) return defaultColor;
    final clean = hexString.replaceAll('#', '').trim();
    if (clean.length == 6) {
      final val = int.tryParse('FF$clean', radix: 16);
      return val != null ? Color(val) : defaultColor;
    } else if (clean.length == 8) {
      final val = int.tryParse(clean, radix: 16);
      return val != null ? Color(val) : defaultColor;
    }
    return defaultColor;
  }

  static String _formatUpdatedTime(DateTime? dateTime) {
    if (dateTime == null) return 'Updated recently.';
    final diff = DateTime.now().toUtc().difference(dateTime.toUtc());
    if (diff.isNegative || diff.inMinutes < 2) return 'Updated just now.';
    if (diff.inMinutes < 60) return '${diff.inMinutes} minutes ago.';
    if (diff.inHours < 24) {
      final hours = diff.inHours;
      return hours == 1 ? '1 hour ago.' : '$hours hours ago.';
    }
    if (diff.inDays < 30) {
      final days = diff.inDays;
      return days == 1 ? '1 day ago.' : '$days days ago.';
    }
    final d = dateTime.toLocal();
    final month = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$month-$day';
  }
}

extension DownloadedArticleEntityEditorialMapper on DownloadedArticleEntity {
  EditorialNewsItem toEditorialNewsItem() {
    return EditorialNewsItem(
      id: id,
      badge: categorySlug.isNotEmpty ? categorySlug.toUpperCase() : 'OFFLINE',
      badgeColor: AppColors.ink,
      title: title,
      updated: '$readingTimeMinutes min read',
      authorName: authorName.isNotEmpty ? authorName : 'Unknown',
      authorRole: authorRole.isNotEmpty ? authorRole : 'Published by',
      authorAvatar: SupabaseStorageService.resolveAvatarUrl(authorAvatar) ?? '',
      excerpt: excerpt.isNotEmpty
          ? excerpt
          : (content.length > 150
                ? '${content.substring(0, 150)}...'
                : content),
      content: content,
      coverImageUrl: SupabaseStorageService.resolveArticleMediaUrl(
        coverImageUrl,
      ),
      coverImageBytes: coverImageBytes,
      authorAvatarBytes: authorAvatarBytes,
      tags: tags,
      publishedAt: publishedAt,
      readingTimeMinutes: readingTimeMinutes,
      status: 'published',
      color: AppColors.cream,
      isLive: false,
      isLiked: false,
      isSaved: true,
    );
  }
}
