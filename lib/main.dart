import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/core/services/shared_preferences_singleton.dart'
    show SharedPreferencesSingleton;
import 'package:mind_feed/features/add_article/presentation/widget/device_preference_notifier.dart';
import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';
import 'package:mind_feed/features/home/domain/entities/downloaded_article_entity.dart';
import 'package:mind_feed/features/settings/presentation/controllers/theme_mode_cubit/theme_mode_cubit.dart';
import 'package:mind_feed/main_app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mind_feed/core/networking/supabase_interceptor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.transparent,
      statusBarColor: AppColors.transparent,
    ),
  );
  globalDevicePreferenceNotifier = DevicePreferenceNotifier();
  await globalDevicePreferenceNotifier.loadDevicePreferences();
  await SharedPreferencesSingleton.init();

  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    publishableKey: AppConstants.supabaseAnonKey,
    httpClient: SupabaseInterceptor(),
  );

  await Hive.initFlutter();
  Hive.registerAdapter(UserEntityAdapter());
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(DownloadedArticleEntityAdapter());
  }
  await Hive.openBox<UserEntity>(AppConstants.userKey);
  setupServiceLocator();
  runApp(
    BlocProvider(create: (context) => ThemeModeCubit(), child: const MyApp()),
  );
}

late DevicePreferenceNotifier globalDevicePreferenceNotifier;
