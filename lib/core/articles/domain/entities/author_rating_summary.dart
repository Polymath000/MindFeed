class AuthorRatingSummary {
  final String authorKey;
  final int userStars;
  final double ratingAvg;
  final int ratingCount;

  const AuthorRatingSummary({
    required this.authorKey,
    required this.userStars,
    required this.ratingAvg,
    required this.ratingCount,
  });

  factory AuthorRatingSummary.fromJson(Map<String, dynamic> json) {
    return AuthorRatingSummary(
      authorKey: json['author_key'] as String? ?? '',
      userStars: (json['user_stars'] as num?)?.toInt() ?? 0,
      ratingAvg: (json['rating_avg'] as num?)?.toDouble() ?? 0.0,
      ratingCount: (json['rating_count'] as num?)?.toInt() ?? 0,
    );
  }
}
