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
  bool isLiked;
  bool isSaved;

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
    this.isLiked = false,
    this.isSaved = false,
  });
}
