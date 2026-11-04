import 'package:flutter/material.dart';

import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';

class CategoryItem {
  final String name;
  final IconData icon;

  const CategoryItem({
    required this.name,
    required this.icon,
  });

  dynamic operator [](int index) {
    if (index == 0) return name;
    if (index == 1) return icon;
    throw RangeError.index(index, this);
  }
}

Color getCategoryColor(String? slugOrNameOrBadge) {
  if (slugOrNameOrBadge == null) return AppColors.ink;
  final normalized = slugOrNameOrBadge.trim().toLowerCase().replaceAll('_', '-');
  return switch (normalized) {
    'science' || 'science & cosmos' || 'science-cosmos' =>
      const Color(0xFF065F46),
    'space' || 'cosmos' => const Color(0xFF7C3AED),
    'technology' ||
    'tech' ||
    'programming & software development' ||
    'programming-software-development' ||
    'programming' ||
    'software development' ||
    'software-development' =>
      const Color(0xFF2563EB),
    'business & entrepreneurship' ||
    'business-entrepreneurship' ||
    'business' ||
    'entrepreneurship' =>
      const Color(0xFF4338CA),
    'personal development' || 'personal-development' => const Color(0xFFD97706),
    'health & wellness' ||
    'health-wellness' ||
    'health' ||
    'wellness' =>
      const Color(0xFF0D9488),
    'education & learning' ||
    'education-learning' ||
    'education' ||
    'learning' =>
      const Color(0xFF4F46E5),
    'news & current events' ||
    'news-current-events' ||
    'news' =>
      const Color(0xFFEF4444),
    'politics' || 'policy' => const Color(0xFF1E293B),
    'finance & investing' ||
    'finance-investing' ||
    'finance' ||
    'economy' ||
    'investing' =>
      const Color(0xFF0E7490),
    'lifestyle' => const Color(0xFFC026D3),
    'travel & culture' ||
    'travel-culture' ||
    'culture' ||
    'travel' =>
      const Color(0xFFEA580C),
    'food & cooking' ||
    'food-cooking' ||
    'food' ||
    'cooking' =>
      const Color(0xFFE11D48),
    'sports' || 'sport' => const Color(0xFF0F172A),
    'entertainment & movies' ||
    'entertainment-movies' ||
    'entertainment' ||
    'movies' =>
      const Color(0xFFDB2777),
    'books & literature' ||
    'books-literature' ||
    'books' ||
    'literature' =>
      const Color(0xFF7C3AED),
    'art & design' ||
    'art-design' ||
    'design' ||
    'art' =>
      const Color(0xFFB45309),
    'history' => const Color(0xFF78350F),
    'psychology' => const Color(0xFF6D28D9),
    'environment & sustainability' ||
    'environment-sustainability' ||
    'climate' ||
    'environment' ||
    'sustainability' =>
      const Color(0xFF047857),
    _ => AppColors.ink,
  };
}

String getCategoryColorHex(String? slugOrNameOrBadge) {
  final color = getCategoryColor(slugOrNameOrBadge);
  final rgb = color.toARGB32() & 0x00FFFFFF;
  return '#${rgb.toRadixString(16).padLeft(6, '0').toUpperCase()}';
}

const List<CategoryItem> categories = [
  CategoryItem(name: 'Technology', icon: AppIcons.technology),
  CategoryItem(name: 'Science', icon: AppIcons.science),
  CategoryItem(
    name: 'Business & Entrepreneurship',
    icon: AppIcons.businessEntrepreneurship,
  ),
  CategoryItem(
    name: 'Personal Development',
    icon: AppIcons.personalDevelopment,
  ),
  CategoryItem(name: 'Health & Wellness', icon: AppIcons.healthWellness),
  CategoryItem(
    name: 'Education & Learning',
    icon: AppIcons.educationLearning,
  ),
  CategoryItem(
    name: 'News & Current Events',
    icon: AppIcons.newsCurrentEvents,
  ),
  CategoryItem(name: 'Politics', icon: AppIcons.politics),
  CategoryItem(
    name: 'Finance & Investing',
    icon: AppIcons.financeInvesting,
  ),
  CategoryItem(name: 'Lifestyle', icon: AppIcons.lifestyle),
  CategoryItem(name: 'Travel & Culture', icon: AppIcons.travelCulture),
  CategoryItem(name: 'Food & Cooking', icon: AppIcons.foodCooking),
  CategoryItem(name: 'Sports', icon: AppIcons.sports),
  CategoryItem(
    name: 'Entertainment & Movies',
    icon: AppIcons.entertainmentMovies,
  ),
  CategoryItem(
    name: 'Books & Literature',
    icon: AppIcons.booksLiterature,
  ),
  CategoryItem(name: 'Art & Design', icon: AppIcons.artDesign),
  CategoryItem(
    name: 'Programming & Software Development',
    icon: AppIcons.programmingSoftwareDevelopment,
  ),
  CategoryItem(name: 'History', icon: AppIcons.history),
  CategoryItem(name: 'Psychology', icon: AppIcons.psychology),
  CategoryItem(
    name: 'Environment & Sustainability',
    icon: AppIcons.environmentSustainability,
  ),
];
