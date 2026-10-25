import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mind_feed/core/constants/constants.dart';

class SupabaseStorageService {
  static const String avatarsBucket = 'avatars';
  static const String articleMediaBucket = 'article-media';
  static const String defaultAvatarFileName = 'defaultAvatar.png';

  final SupabaseClient? _supabaseClient;

  const SupabaseStorageService({SupabaseClient? supabaseClient})
    : _supabaseClient = supabaseClient;

  SupabaseClient? get _client {
    if (_supabaseClient != null) return _supabaseClient;
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  /// Resolves an avatar URL or storage path inside the `avatars` bucket.
  /// Returns `null` when [rawUrlOrPath] is null, empty, or a legacy local asset path.
  static String? resolveAvatarUrl(
    String? rawUrlOrPath, {
    SupabaseClient? client,
  }) {
    if (rawUrlOrPath == null) return null;
    final trimmed = rawUrlOrPath.trim();
    if (trimmed.isEmpty || trimmed.startsWith('assets/')) {
      return null;
    }
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    final cleanPath = _normalizeBucketObjectPath(trimmed, avatarsBucket);
    if (cleanPath.isEmpty) return null;
    return _buildPublicUrl(avatarsBucket, cleanPath, client: client);
  }

  /// Resolves an article image URL or storage path inside the `article-media` bucket.
  static String? resolveArticleMediaUrl(
    String? rawUrlOrPath, {
    SupabaseClient? client,
  }) {
    if (rawUrlOrPath == null) return null;
    final trimmed = rawUrlOrPath.trim();
    if (trimmed.isEmpty || trimmed.startsWith('assets/')) {
      return null;
    }
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    final cleanPath = _normalizeBucketObjectPath(trimmed, articleMediaBucket);
    if (cleanPath.isEmpty) return null;
    return _buildPublicUrl(articleMediaBucket, cleanPath, client: client);
  }

  /// Returns true if [urlOrPath] is empty or points to the default avatar in Supabase.
  static bool isDefaultAvatar(String? urlOrPath) {
    if (urlOrPath == null) return true;
    final trimmed = urlOrPath.trim();
    if (trimmed.isEmpty) return true;
    final clean = trimmed.split('?').first;
    return clean == defaultAvatarFileName ||
        clean.endsWith('/$defaultAvatarFileName');
  }

  /// Extracts the object path inside [bucketName] from a full URL or relative path.
  static String? extractBucketPath(String? urlOrPath, String bucketName) {
    if (urlOrPath == null) return null;
    final trimmed = urlOrPath.trim();
    if (trimmed.isEmpty || trimmed.startsWith('assets/')) return null;

    final withoutQuery = trimmed.split('?').first;
    final marker = '/storage/v1/object/public/$bucketName/';
    final markerIdx = withoutQuery.indexOf(marker);
    if (markerIdx != -1) {
      final extracted = withoutQuery.substring(markerIdx + marker.length);
      return extracted.isNotEmpty ? Uri.decodeFull(extracted) : null;
    }
    if (withoutQuery.startsWith('http://') ||
        withoutQuery.startsWith('https://')) {
      return null;
    }
    final normalized = _normalizeBucketObjectPath(withoutQuery, bucketName);
    return normalized.isNotEmpty ? normalized : null;
  }

  static String _normalizeBucketObjectPath(String rawPath, String bucketName) {
    var clean = rawPath.trim();
    while (clean.startsWith('/')) {
      clean = clean.substring(1);
    }
    if (clean.startsWith('$bucketName/')) {
      clean = clean.substring(bucketName.length + 1);
    }
    return clean;
  }

  static String? _buildPublicUrl(
    String bucketName,
    String objectPath, {
    SupabaseClient? client,
  }) {
    try {
      final activeClient = client ?? Supabase.instance.client;
      return activeClient.storage.from(bucketName).getPublicUrl(objectPath);
    } catch (_) {
      final baseUrl = AppConstants.supabaseUrl.trim();
      if (baseUrl.isNotEmpty) {
        final normalizedBase = baseUrl.endsWith('/')
            ? baseUrl.substring(0, baseUrl.length - 1)
            : baseUrl;
        return '$normalizedBase/storage/v1/object/public/$bucketName/$objectPath';
      }
      return 'https://tsqruoqiajkbrdhprfxa.supabase.co/storage/v1/object/public/$bucketName/$objectPath';
    }
  }

  static String normalizeExtension(String fileNameOrExtension) {
    final cleaned = fileNameOrExtension.trim().toLowerCase();
    final rawExt = cleaned.contains('.') ? cleaned.split('.').last : cleaned;
    return switch (rawExt) {
      'jpg' || 'jpeg' => 'jpg',
      'png' => 'png',
      'webp' => 'webp',
      'gif' => 'gif',
      _ => 'jpg',
    };
  }

  static String contentTypeForExtension(String ext) {
    return switch (ext) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      'gif' => 'image/gif',
      _ => 'image/jpeg',
    };
  }

  /// Deletes the previous avatar from `avatars` (if it belongs to `avatars` and is not `defaultAvatar.png`)
  /// and uploads the new avatar bytes, returning the public URL.
  Future<String> uploadAvatar({
    required String userId,
    required Uint8List bytes,
    required String fileExtension,
    String? previousAvatarUrl,
  }) async {
    final client = _client;
    if (client == null) {
      throw const StorageException('Storage client is not initialized');
    }

    if (previousAvatarUrl != null && !isDefaultAvatar(previousAvatarUrl)) {
      final oldPath = extractBucketPath(previousAvatarUrl, avatarsBucket);
      if (oldPath != null &&
          oldPath.isNotEmpty &&
          oldPath != defaultAvatarFileName &&
          !oldPath.endsWith('/$defaultAvatarFileName')) {
        try {
          await client.storage.from(avatarsBucket).remove([oldPath]);
        } catch (_) {}
      }
    }

    final ext = normalizeExtension(fileExtension);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final objectPath = '$userId/avatar_$timestamp.$ext';

    await client.storage.from(avatarsBucket).uploadBinary(
          objectPath,
          bytes,
          fileOptions: FileOptions(
            upsert: true,
            contentType: contentTypeForExtension(ext),
          ),
        );

    return client.storage.from(avatarsBucket).getPublicUrl(objectPath);
  }

  /// Uploads an article cover image to `article-media` (removing any previous cover in `article-media` if owned by user)
  /// and returns its public URL.
  Future<String> uploadArticleCover({
    required String userId,
    required Uint8List bytes,
    required String fileExtension,
    String? previousCoverUrl,
  }) async {
    final client = _client;
    if (client == null) {
      throw const StorageException('Storage client is not initialized');
    }

    if (previousCoverUrl != null && previousCoverUrl.trim().isNotEmpty) {
      final oldPath = extractBucketPath(previousCoverUrl, articleMediaBucket);
      if (oldPath != null && oldPath.startsWith('$userId/')) {
        try {
          await client.storage.from(articleMediaBucket).remove([oldPath]);
        } catch (_) {}
      }
    }

    final ext = normalizeExtension(fileExtension);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final objectPath = '$userId/cover_$timestamp.$ext';

    await client.storage.from(articleMediaBucket).uploadBinary(
          objectPath,
          bytes,
          fileOptions: FileOptions(
            upsert: true,
            contentType: contentTypeForExtension(ext),
          ),
        );

    return client.storage.from(articleMediaBucket).getPublicUrl(objectPath);
  }
}
