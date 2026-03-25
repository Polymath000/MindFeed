import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart' show Hive;
import 'package:hive_flutter/adapters.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/core/helpers/setup_service_locator.dart';
import 'package:mind_feed/core/services/shared_preferences_singleton.dart'
    show SharedPreferencesSingleton;
import 'package:mind_feed/features/add_article/presentation/widget/device_preference_notifier.dart';
import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';
import 'package:mind_feed/features/settings/presentation/controllers/theme_mode_cubit/theme_mode_cubit.dart';
import 'package:mind_feed/main_app.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.transparent,
      statusBarColor: AppColors.transparent,
    ),
  );
  globalDevicePreferenceNotifier = DevicePreferenceNotifier();
  await globalDevicePreferenceNotifier.loadDevicePreferences();
  await SharedPreferencesSingleton.init();
  await Hive.initFlutter();
  // Hive.registerAdapter(ModelAdapter());
  await Hive.openBox<UserEntity>(userKey);
  setupServiceLocator();
  runApp(
    BlocProvider(create: (context) => ThemeModeCubit(), child: const MyApp()),
  );
}

late DevicePreferenceNotifier globalDevicePreferenceNotifier;
