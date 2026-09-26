import 'package:flutter/material.dart';
import 'package:mind_feed/core/design/editorial_design.dart';

class SecurityTipText extends StatelessWidget {
  const SecurityTipText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF262422),
        border: Border.all(color: const Color(0xFF383530)),
        borderRadius: EditorialRadii.card,
      ),
      padding: const EdgeInsets.all(16),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.shield_outlined,
            color: EditorialPalette.cream,
            size: 20,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Security Recommendation',
                  style: TextStyle(
                    color: EditorialPalette.softCream,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Use a unique, resilient passphrase. A dedicated password manager ensures strong protection across your reading devices.',
                  style: TextStyle(
                    color: Color(0xFFAAA49B),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
