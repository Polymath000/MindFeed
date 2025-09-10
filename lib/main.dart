import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/services/shared_preferences_singleton.dart'
    show SharedPreferencesSingleton;
import 'package:mind_feed/features/settings/presentation/controllers/theme_mode_cubit/theme_mode_cubit.dart';
import 'package:mind_feed/main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPreferencesSingleton.init();
  runApp(
    BlocProvider(create: (context) => ThemeModeCubit(), child: const MyApp()),
  );
}
