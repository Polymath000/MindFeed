import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';

class UserFeedTopicsResult {
  final List<String> topics;
  final List<String> preferredCategoryIds;

  const UserFeedTopicsResult({
    required this.topics,
    required this.preferredCategoryIds,
  });
}

class GetUserFeedTopicsUseCase {
  final ProfileRepository? profileRepository;

  const GetUserFeedTopicsUseCase({this.profileRepository});

  static List<String> buildInitialTopics(List<String>? cachedCategories) {
    if (cachedCategories == null || cachedCategories.isEmpty) {
      return const ['All'];
    }
    final topics = <String>['All'];
    for (final cat in cachedCategories) {
      final trimmed = cat.trim();
      if (trimmed.isNotEmpty && !topics.contains(trimmed)) {
        topics.add(trimmed);
      }
    }
    return topics;
  }

  Future<UserFeedTopicsResult> call({
    String? userId,
    bool shouldQueryRemote = true,
    List<String>? cachedCategories,
  }) async {
    final preferredCategoryIds = <String>[];
    final dynamicTopics = <String>[];

    if (profileRepository != null && shouldQueryRemote) {
      await _loadRemoteFavorites(
        userId ?? '',
        preferredCategoryIds,
        dynamicTopics,
      );
    }

    if (dynamicTopics.isEmpty && cachedCategories != null) {
      _appendCachedTopics(cachedCategories, dynamicTopics);
    }

    if (preferredCategoryIds.isEmpty &&
        dynamicTopics.isNotEmpty &&
        profileRepository != null) {
      await _resolveCategoryIdsByName(dynamicTopics, preferredCategoryIds);
    }

    return UserFeedTopicsResult(
      topics: <String>['All', ...dynamicTopics],
      preferredCategoryIds: preferredCategoryIds,
    );
  }

  Future<void> _loadRemoteFavorites(
    String userId,
    List<String> preferredIds,
    List<String> dynamicTopics,
  ) async {
    try {
      final result = await profileRepository!.getFavoriteCategories(userId);
      result.when(
        success: (favs) => _parseFavoriteMaps(favs, preferredIds, dynamicTopics),
        failure: (_) {},
      );
    } catch (_) {}
  }

  void _parseFavoriteMaps(
    List<Map<String, dynamic>> favs,
    List<String> preferredIds,
    List<String> dynamicTopics,
  ) {
    for (final f in favs) {
      final catId = f['category_id'] as String?;
      if (catId != null && catId.isNotEmpty && !preferredIds.contains(catId)) {
        preferredIds.add(catId);
      }
      final name = _extractCategoryName(f);
      if (name != null &&
          name.isNotEmpty &&
          name != 'All' &&
          !dynamicTopics.contains(name)) {
        dynamicTopics.add(name);
      }
    }
  }

  String? _extractCategoryName(Map<String, dynamic> map) {
    final raw = (map['name'] as String?) ??
        (map['category_name'] as String?) ??
        (map['categories'] as Map<String, dynamic>?)?['name'] as String?;
    return raw?.trim();
  }

  void _appendCachedTopics(
    List<String> cachedCategories,
    List<String> dynamicTopics,
  ) {
    for (final rawName in cachedCategories) {
      final name = rawName.trim();
      if (name.isNotEmpty &&
          name != 'All' &&
          !dynamicTopics.contains(name)) {
        dynamicTopics.add(name);
      }
    }
  }

  Future<void> _resolveCategoryIdsByName(
    List<String> dynamicTopics,
    List<String> preferredIds,
  ) async {
    try {
      final catResult = await profileRepository!.getCategories();
      catResult.when(
        success: (allCats) => _matchCategoryIds(allCats, dynamicTopics, preferredIds),
        failure: (_) {},
      );
    } catch (_) {}
  }

  void _matchCategoryIds(
    List<Map<String, dynamic>> allCats,
    List<String> dynamicTopics,
    List<String> preferredIds,
  ) {
    final lowerFavs = dynamicTopics.map((e) => e.toLowerCase()).toSet();
    for (final c in allCats) {
      final name = (c['name'] as String?)?.trim();
      final id = c['id'] as String?;
      if (name != null &&
          id != null &&
          lowerFavs.contains(name.toLowerCase()) &&
          !preferredIds.contains(id)) {
        preferredIds.add(id);
      }
    }
  }
}
