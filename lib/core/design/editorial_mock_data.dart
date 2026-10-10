import 'package:flutter/material.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/utls/app_images.dart';

class EditorialMockData {
  EditorialMockData._();

  static List<EditorialNewsItem> get stories => [
    EditorialNewsItem(
      id: 'story_indian_generic_drugs',
      badge: 'LIVE',
      badgeColor: const Color(0xFFEF4444),
      title: 'Demand for Indian\ngeneric drugs\nskyrockets in...',
      updated: 'Updated just now.',
      authorName: 'Wade Warren',
      authorRole: 'Published by',
      authorAvatar: Assets.assetsImagesWadeAvatar,
      excerpt:
          'The demand for Indian generic drugs has shot up in China amid the massive COVID surge in the country, with Chinese experts cautioning that fake versions of these drugs are flooding the market.',
      color: EditorialPalette.cream,
      isLive: true,
    ),
    EditorialNewsItem(
      id: 'story_quantum_breakthrough',
      badge: 'SCIENCE',
      badgeColor: const Color(0xFF059669),
      title: 'Quantum Coherence\nAchieved at Room\nTemperature in Lab',
      updated: '12 minutes ago.',
      authorName: 'Dr. Elena Rostova',
      authorRole: 'Senior Science Editor',
      authorAvatar: Assets.assetsImagesWadeAvatar,
      excerpt:
          'Physicists have sustained quantum entanglement across a synthetic diamond lattice at ambient temperatures, unlocking unprecedented possibilities for practical quantum computing and secure communication.',
      color: EditorialPalette.mint,
    ),
    EditorialNewsItem(
      id: 'story_novak_djokovic',
      badge: 'SPORT',
      badgeColor: EditorialPalette.ink,
      title: 'Novak Djokovic, Nick\nKyrgios To Play\nShowcase Match',
      updated: '24 minutes ago.',
      authorName: 'Marcus Chen',
      authorRole: 'Sports Correspondent',
      authorAvatar: Assets.assetsImagesWadeAvatar,
      excerpt:
          'Novak Djokovic and Nick Kyrgios will play a highly anticipated exhibition practice match ahead of the Australian Open tournament in Melbourne before sold-out crowds.',
      color: EditorialPalette.blush,
    ),
    EditorialNewsItem(
      id: 'story_apple_retail_expansion',
      badge: 'TECH',
      badgeColor: const Color(0xFF2563EB),
      title: 'Apple Hiring Workers for\nFlagship Retail Stores\nAcross Major Hubs',
      updated: '1 hour ago.',
      authorName: 'Sophia Dubois',
      authorRole: 'Tech & Markets',
      authorAvatar: Assets.assetsImagesWadeAvatar,
      excerpt:
          'Apple is preparing to staff multiple next-generation retail store locations designed with zero-emission architecture and open creative community amphitheaters.',
      color: EditorialPalette.powder,
    ),
    EditorialNewsItem(
      id: 'story_neural_prosthetics',
      badge: 'HEALTH',
      badgeColor: const Color(0xFFD97706),
      title: 'Next-Gen Bionic Limbs\nRestore Subtle Touch\nSensations',
      updated: '2 hours ago.',
      authorName: 'Dr. Aris Thorne',
      authorRole: 'Medical Tech Fellow',
      authorAvatar: Assets.assetsImagesWadeAvatar,
      excerpt:
          'Clinical trials reveal bio-integrated neural sensors can feed tactile pressure feedback directly to peripheral nerves, enabling patients to identify textures with their eyes closed.',
      color: EditorialPalette.peach,
    ),
    EditorialNewsItem(
      id: 'story_meta_content_policy',
      badge: 'POLICY',
      badgeColor: EditorialPalette.ink,
      title: 'Facebook Owner Meta\nRevises Content Safety\nGovernance System',
      updated: '3 hours ago.',
      authorName: 'Liam Vance',
      authorRole: 'Digital Rights Reporter',
      authorAvatar: Assets.assetsImagesWadeAvatar,
      excerpt:
          'Meta is deploying decentralized review boards and transparent heuristic filters across its global platforms to mitigate synthetic misinformation.',
      color: EditorialPalette.lilac,
    ),
    EditorialNewsItem(
      id: 'story_deep_space_survey',
      badge: 'SPACE',
      badgeColor: const Color(0xFF7C3AED),
      title: 'James Webb Space\nTelescope Detects Water\nin Exoplanet Core',
      updated: '4 hours ago.',
      authorName: 'Dr. Elena Rostova',
      authorRole: 'Astrophysics Lead',
      authorAvatar: Assets.assetsImagesWadeAvatar,
      excerpt:
          'Spectroscopic observations of LHS 475 b uncover unmistakable signatures of atmospheric water vapor and atmospheric methane, sparking renewed astrobiology research.',
      color: EditorialPalette.sand,
    ),
    EditorialNewsItem(
      id: 'story_clean_energy_grid',
      badge: 'CLIMATE',
      badgeColor: const Color(0xFF047857),
      title: 'Nordic Power Grid\nSurpasses 98 Percent\nRenewable Benchmark',
      updated: '5 hours ago.',
      authorName: 'Frederik Lind',
      authorRole: 'Energy Analyst',
      authorAvatar: Assets.assetsImagesWadeAvatar,
      excerpt:
          'Interconnected wind corridors, pumped hydro storage, and geothermal balancing networks enabled northern European territories to maintain continuous baseline supply without fossil backup.',
      color: EditorialPalette.mint,
    ),
    EditorialNewsItem(
      id: 'story_generative_agents',
      badge: 'AI',
      badgeColor: const Color(0xFF4F46E5),
      title: 'Autonomous Software\nAgents Transform System\nArchitecture Work',
      updated: '6 hours ago.',
      authorName: 'Sophia Dubois',
      authorRole: 'AI & Systems',
      authorAvatar: Assets.assetsImagesWadeAvatar,
      excerpt:
          'Engineering teams report 40 percent faster refactoring cycles as cooperative agent swarms conduct multi-file code transformations, regression testing, and security hardening.',
      color: EditorialPalette.cream,
    ),
    EditorialNewsItem(
      id: 'story_minimalist_typography',
      badge: 'DESIGN',
      badgeColor: const Color(0xFFB45309),
      title: 'The Resurgence of\nTactile Print Sensibility\nin Digital Reading',
      updated: '7 hours ago.',
      authorName: 'Julian Haze',
      authorRole: 'Design Director',
      authorAvatar: Assets.assetsImagesWadeAvatar,
      excerpt:
          'Modern application interfaces are shedding flat monochromatic sameness in favor of expressive editorial typefaces, warm paper surfaces, and natural physics-driven layouts.',
      color: EditorialPalette.blush,
    ),
    EditorialNewsItem(
      id: 'story_global_microchip_accord',
      badge: 'ECONOMY',
      badgeColor: const Color(0xFF0E7490),
      title: 'Allied Nations Sign\nHistoric Semiconductor\nSupply Chain Compact',
      updated: '8 hours ago.',
      authorName: 'Amara Kalu',
      authorRole: 'Economics Lead',
      authorAvatar: Assets.assetsImagesWadeAvatar,
      excerpt:
          'A multilateral agreement establishes shared silicon fabrication reserves, joint research consortia, and strategic stockpiles to cushion automotive and electronics industries against disruptions.',
      color: EditorialPalette.powder,
    ),
    EditorialNewsItem(
      id: 'story_deep_sea_biodiversity',
      badge: 'SCIENCE',
      badgeColor: const Color(0xFF065F46),
      title: 'Expedition Uncovers\nOver 100 Unknown\nDeep-Ocean Species',
      updated: '9 hours ago.',
      authorName: 'Dr. Aris Thorne',
      authorRole: 'Marine Ecology',
      authorAvatar: Assets.assetsImagesWadeAvatar,
      excerpt:
          'Submersible robotic surveys along the Mariana Trench margins catalog bioluminescent cephalopods and chemosynthetic organisms flourishing without sunlight.',
      color: EditorialPalette.peach,
    ),
    EditorialNewsItem(
      id: 'story_champions_league_final',
      badge: 'SPORT',
      badgeColor: EditorialPalette.ink,
      title: 'European Football Final\nSets Global Streaming\nViewership Record',
      updated: '10 hours ago.',
      authorName: 'Marcus Chen',
      authorRole: 'Sports Editor',
      authorAvatar: Assets.assetsImagesWadeAvatar,
      excerpt:
          'More than 450 million concurrent viewers tuned in across digital platforms to witness a thrilling stoppage-time decider under Wembley stadium lights.',
      color: EditorialPalette.lilac,
    ),
    EditorialNewsItem(
      id: 'story_cognitive_wellness',
      badge: 'HEALTH',
      badgeColor: const Color(0xFFE11D48),
      title: 'Circadian Alignment\nProven to Enhance Neural\nMemory Retention',
      updated: '11 hours ago.',
      authorName: 'Wade Warren',
      authorRole: 'Wellness Columnist',
      authorAvatar: Assets.assetsImagesWadeAvatar,
      excerpt:
          'Neurologists confirm that synchronized morning daylight exposure and evening dimming cycles significantly improve synaptic plasticity and long-term memory recall in adults.',
      color: EditorialPalette.sand,
    ),
  ];

  static List<EditorialNewsItem> get savedStories =>
      stories.where((s) => s.isLive || s.badge == 'SPORT' || s.badge == 'TECH' || s.badge == 'AI').toList();

  static List<EditorialNewsItem> get userArticles => [
    stories[0],
    stories[1],
    stories[3],
    stories[8],
    stories[9],
  ];
}
