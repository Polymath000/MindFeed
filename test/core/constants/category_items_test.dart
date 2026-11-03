import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/category_items.dart';

void main() {
  group('getCategoryColor', () {
    test('returns exact colors for all primary and alias categories', () {
      expect(getCategoryColor('science'), const Color(0xFF065F46));
      expect(getCategoryColor('space'), const Color(0xFF7C3AED));
      expect(getCategoryColor('technology'), const Color(0xFF2563EB));
      expect(
        getCategoryColor('programming & software development'),
        const Color(0xFF2563EB),
      );
      expect(
        getCategoryColor('programming-software-development'),
        const Color(0xFF2563EB),
      );
      expect(
        getCategoryColor('business & entrepreneurship'),
        const Color(0xFF4338CA),
      );
      expect(
        getCategoryColor('business-entrepreneurship'),
        const Color(0xFF4338CA),
      );
      expect(getCategoryColor('business'), const Color(0xFF4338CA));
      expect(
        getCategoryColor('personal development'),
        const Color(0xFFD97706),
      );
      expect(
        getCategoryColor('personal-development'),
        const Color(0xFFD97706),
      );
      expect(getCategoryColor('health & wellness'), const Color(0xFF0D9488));
      expect(getCategoryColor('health-wellness'), const Color(0xFF0D9488));
      expect(getCategoryColor('health'), const Color(0xFF0D9488));
      expect(
        getCategoryColor('education & learning'),
        const Color(0xFF4F46E5),
      );
      expect(
        getCategoryColor('education-learning'),
        const Color(0xFF4F46E5),
      );
      expect(getCategoryColor('education'), const Color(0xFF4F46E5));
      expect(
        getCategoryColor('news & current events'),
        const Color(0xFFEF4444),
      );
      expect(
        getCategoryColor('news-current-events'),
        const Color(0xFFEF4444),
      );
      expect(getCategoryColor('news'), const Color(0xFFEF4444));
      expect(getCategoryColor('politics'), const Color(0xFF1E293B));
      expect(getCategoryColor('policy'), const Color(0xFF1E293B));
      expect(
        getCategoryColor('finance & investing'),
        const Color(0xFF0E7490),
      );
      expect(
        getCategoryColor('finance-investing'),
        const Color(0xFF0E7490),
      );
      expect(getCategoryColor('finance'), const Color(0xFF0E7490));
      expect(getCategoryColor('economy'), const Color(0xFF0E7490));
      expect(getCategoryColor('lifestyle'), const Color(0xFFC026D3));
      expect(getCategoryColor('travel & culture'), const Color(0xFFEA580C));
      expect(getCategoryColor('travel-culture'), const Color(0xFFEA580C));
      expect(getCategoryColor('culture'), const Color(0xFFEA580C));
      expect(getCategoryColor('food & cooking'), const Color(0xFFE11D48));
      expect(getCategoryColor('food-cooking'), const Color(0xFFE11D48));
      expect(getCategoryColor('sports'), const Color(0xFF0F172A));
      expect(getCategoryColor('sport'), const Color(0xFF0F172A));
      expect(
        getCategoryColor('entertainment & movies'),
        const Color(0xFFDB2777),
      );
      expect(
        getCategoryColor('entertainment-movies'),
        const Color(0xFFDB2777),
      );
      expect(getCategoryColor('books & literature'), const Color(0xFF7C3AED));
      expect(getCategoryColor('books-literature'), const Color(0xFF7C3AED));
      expect(getCategoryColor('art & design'), const Color(0xFFB45309));
      expect(getCategoryColor('art-design'), const Color(0xFFB45309));
      expect(getCategoryColor('design'), const Color(0xFFB45309));
      expect(getCategoryColor('history'), const Color(0xFF78350F));
      expect(getCategoryColor('psychology'), const Color(0xFF6D28D9));
      expect(
        getCategoryColor('environment & sustainability'),
        const Color(0xFF047857),
      );
      expect(
        getCategoryColor('environment-sustainability'),
        const Color(0xFF047857),
      );
      expect(getCategoryColor('climate'), const Color(0xFF047857));
    });

    test('handles case insensitivity, whitespace, underscores, and badge uppercase', () {
      expect(getCategoryColor('  SCIENCE  '), const Color(0xFF065F46));
      expect(getCategoryColor('TECHNOLOGY'), const Color(0xFF2563EB));
      expect(
        getCategoryColor('programming_software_development'),
        const Color(0xFF2563EB),
      );
      expect(
        getCategoryColor('HEALTH_WELLNESS'),
        const Color(0xFF0D9488),
      );
    });

    test('returns default AppColors.ink for null, empty, or unknown category', () {
      expect(getCategoryColor(null), AppColors.ink);
      expect(getCategoryColor(''), AppColors.ink);
      expect(getCategoryColor('   '), AppColors.ink);
      expect(getCategoryColor('unknown_category'), AppColors.ink);
    });
  });

  group('getCategoryColorHex', () {
    test('returns uppercase #RRGGBB format for categories and defaults', () {
      expect(getCategoryColorHex('science'), '#065F46');
      expect(getCategoryColorHex('space'), '#7C3AED');
      expect(getCategoryColorHex('technology'), '#2563EB');
      expect(getCategoryColorHex('business'), '#4338CA');
      expect(getCategoryColorHex('personal-development'), '#D97706');
      expect(getCategoryColorHex('health'), '#0D9488');
      expect(getCategoryColorHex('education'), '#4F46E5');
      expect(getCategoryColorHex('news'), '#EF4444');
      expect(getCategoryColorHex('politics'), '#1E293B');
      expect(getCategoryColorHex('finance'), '#0E7490');
      expect(getCategoryColorHex('lifestyle'), '#C026D3');
      expect(getCategoryColorHex('travel-culture'), '#EA580C');
      expect(getCategoryColorHex('food-cooking'), '#E11D48');
      expect(getCategoryColorHex('sports'), '#0F172A');
      expect(getCategoryColorHex('entertainment-movies'), '#DB2777');
      expect(getCategoryColorHex('books-literature'), '#7C3AED');
      expect(getCategoryColorHex('art-design'), '#B45309');
      expect(getCategoryColorHex('history'), '#78350F');
      expect(getCategoryColorHex('psychology'), '#6D28D9');
      expect(getCategoryColorHex('environment-sustainability'), '#047857');
      expect(getCategoryColorHex(null), '#171614');
      expect(getCategoryColorHex(''), '#171614');
      expect(getCategoryColorHex('unknown'), '#171614');
    });
  });
}
