import 'package:flutter/material.dart';
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
