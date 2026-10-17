import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_colors.dart';

Future<void> showPrivacyManifestDialog(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.whiteLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MindFeed Editorial Charter',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '1. Zero Ad-Trackers: Your reading habits are never logged or auctioned to advertising exchanges.\n2. Verified Byline Integrity: Every piece is verified by human editors before syndication.\n3. Reader Sovereignty: Offline archives and cached journals remain entirely on your personal device.',
            style: TextStyle(
              fontSize: 13.5,
              height: 1.5,
              color: AppColors.mutedInk,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.ink,
                foregroundColor: AppColors.cream,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Understood'),
            ),
          ),
        ],
      ),
    ),
  );
}

Future<String?> showDigestPickerSheet(BuildContext context, String current) {
  final options = ['Daily Morning', 'Weekly Digest', 'Instant Breaking'];
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.whiteLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Digest Delivery Cadence',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink),
          ),
          const SizedBox(height: 16),
          ...options.map((opt) => ListTile(
                title: Text(opt, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.ink)),
                trailing: opt == current ? const Icon(Icons.check, color: AppColors.ink) : null,
                onTap: () => Navigator.pop(ctx, opt),
              )),
        ],
      ),
    ),
  );
}

Future<void> showEditProfileSheet(
  BuildContext context, {
  required String initialName,
  required String initialEmail,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.whiteLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Profile Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink)),
          const SizedBox(height: 12),
          Text('Name: $initialName', style: const TextStyle(fontSize: 14, color: AppColors.mutedInk)),
          const SizedBox(height: 6),
          Text('Email: $initialEmail', style: const TextStyle(fontSize: 14, color: AppColors.mutedInk)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.ink,
                foregroundColor: AppColors.cream,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close'),
            ),
          ),
        ],
      ),
    ),
  );
}

Future<void> showSignOutDialog(BuildContext context, Future<void> Function() onConfirm) {
  return showDialog(
    context: context,
    builder: (dialogCtx) => AlertDialog(
      backgroundColor: AppColors.whiteLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Sign Out', style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w800)),
      content: const Text(
        'Are you sure you want to sign out of MindFeed on this device?',
        style: TextStyle(color: AppColors.mutedInk, fontSize: 14),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('Cancel', style: TextStyle(color: AppColors.greyText))),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.ink,
            foregroundColor: AppColors.cream,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () async {
            Navigator.pop(dialogCtx);
            await onConfirm();
          },
          child: const Text('Sign Out'),
        ),
      ],
    ),
  );
}
