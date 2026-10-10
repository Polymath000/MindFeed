import re
with open("lib/config/routes/app_routes.dart", "r") as f:
    content = f.read()

content = content.replace(
    "return MaterialPageRoute(builder: (_) => const SettingsView(), settings: settings);",
    "return MaterialPageRoute(builder: (_) => BlocProvider(create: (_) => SettingsCubit()..loadSettings(), child: const SettingsView()), settings: settings);"
)

if "import 'package:mind_feed/features/settings/presentation/controllers/settings_cubit/settings_cubit.dart';" not in content:
    content = "import 'package:mind_feed/features/settings/presentation/controllers/settings_cubit/settings_cubit.dart';\n" + content

with open("lib/config/routes/app_routes.dart", "w") as f:
    f.write(content)
