import re

with open("lib/features/settings/presentation/widgets/settings_view_body.dart", "r") as f:
    content = f.read()

# Add imports
if "import 'package:flutter_bloc/flutter_bloc.dart';" not in content:
    content = "import 'package:flutter_bloc/flutter_bloc.dart';\n" + content
if "import 'package:mind_feed/features/settings/presentation/controllers/settings_cubit/settings_cubit.dart';" not in content:
    content = "import 'package:mind_feed/features/settings/presentation/controllers/settings_cubit/settings_cubit.dart';\n" + content

# Change StatefulWidget to StatlessWidget if we want, or just leave it but replace state vars
# But let's just replace the specific widget that uses the settings.
# Actually, it's easier to just inject SettingsCubit in app_routes.dart and wrap the body with BlocBuilder.
