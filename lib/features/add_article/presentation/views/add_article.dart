import 'package:flutter/material.dart';
import 'package:mind_feed/features/add_article/presentation/views/home_of_add_article_view.dart';
import 'package:mind_feed/features/add_article/presentation/widget/device_preference_notifier.dart';
import 'package:mind_feed/main.dart';

class AddArticleView extends StatelessWidget {
  AddArticleView({super.key});
  static const String routeName = 'Add Article';

  @override
  Widget build(BuildContext context) {
    return MarkdownEditorApp();
  }
}

class MarkdownEditorApp extends StatelessWidget {
  const MarkdownEditorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DevicePreferences>(
      valueListenable: globalDevicePreferenceNotifier,
      builder: (context, devicePreference, _) {
        return Home(devicePreferenceNotifier: globalDevicePreferenceNotifier);
      },
    );
  }
}
