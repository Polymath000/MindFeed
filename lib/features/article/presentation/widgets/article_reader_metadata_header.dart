import 'package:flutter/material.dart';

import 'package:mind_feed/core/constants/app_text_styles.dart';

class ArticleReaderMetadataHeader extends StatelessWidget {
  const ArticleReaderMetadataHeader({
    super.key,
    required this.title,
    required this.updated,
    required this.readingTimeMinutes,
  });

  final String title;
  final String updated;
  final int readingTimeMinutes;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.replaceAll('\n', ' '),
          style: AppTextStyles.readerHeadline,
        ),
        const SizedBox(height: 10),
        _MetadataSummaryRow(
          updated: updated,
          readingTimeMinutes: readingTimeMinutes,
        ),
      ],
    );
  }
}

class _MetadataSummaryRow extends StatelessWidget {
  const _MetadataSummaryRow({
    required this.updated,
    required this.readingTimeMinutes,
  });

  final String updated;
  final int readingTimeMinutes;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          updated,
          style: AppTextStyles.readerUpdatedDate,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('•', style: AppTextStyles.readerMetadataDot),
        ),
        Text(
          '$readingTimeMinutes min read',
          style: AppTextStyles.readerReadingTime,
        ),
      ],
    );
  }
}
