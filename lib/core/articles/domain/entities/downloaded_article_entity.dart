import 'dart:typed_data';

class DownloadedArticleEntity {
  final String id;
  final String title;
  final String excerpt;
  final String content;
  final String authorName;
  final String authorRole;
  final String authorAvatar;
  final String categoryId;
  final String categorySlug;
  final List<String> tags;
  final DateTime publishedAt;
  final int readingTimeMinutes;
  final DateTime downloadedAt;
  final String? coverImageUrl;
  final Uint8List? coverImageBytes;
  final Uint8List? authorAvatarBytes;

  const DownloadedArticleEntity({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.content,
    required this.authorName,
    required this.authorRole,
    required this.authorAvatar,
    required this.categoryId,
    required this.categorySlug,
    required this.tags,
    required this.publishedAt,
    required this.readingTimeMinutes,
    required this.downloadedAt,
    this.coverImageUrl,
    this.coverImageBytes,
    this.authorAvatarBytes,
  });

  DownloadedArticleEntity copyWith({
    String? id,
    String? title,
    String? excerpt,
    String? content,
    String? authorName,
    String? authorRole,
    String? authorAvatar,
    String? categoryId,
    String? categorySlug,
    List<String>? tags,
    DateTime? publishedAt,
    int? readingTimeMinutes,
    DateTime? downloadedAt,
    String? coverImageUrl,
    Uint8List? coverImageBytes,
    Uint8List? authorAvatarBytes,
  }) {
    return DownloadedArticleEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      excerpt: excerpt ?? this.excerpt,
      content: content ?? this.content,
      authorName: authorName ?? this.authorName,
      authorRole: authorRole ?? this.authorRole,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      categoryId: categoryId ?? this.categoryId,
      categorySlug: categorySlug ?? this.categorySlug,
      tags: tags ?? this.tags,
      publishedAt: publishedAt ?? this.publishedAt,
      readingTimeMinutes: readingTimeMinutes ?? this.readingTimeMinutes,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      coverImageBytes: coverImageBytes ?? this.coverImageBytes,
      authorAvatarBytes: authorAvatarBytes ?? this.authorAvatarBytes,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadedArticleEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
