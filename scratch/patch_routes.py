import re
with open("lib/config/routes/app_routes.dart", "r") as f:
    content = f.read()

content = content.replace(
    "return MaterialPageRoute(builder: (_) => const ArticlesSaved(), settings: settings);",
    "return MaterialPageRoute(builder: (_) => BlocProvider(create: (_) => CollectionsCubit(), child: const ArticlesSaved()), settings: settings);"
)

if "import 'package:flutter_bloc/flutter_bloc.dart';" not in content:
    content = "import 'package:flutter_bloc/flutter_bloc.dart';\n" + content

if "import 'package:mind_feed/features/collections/presentation/cubit/collections_cubit.dart';" not in content:
    content = "import 'package:mind_feed/features/collections/presentation/cubit/collections_cubit.dart';\n" + content

with open("lib/config/routes/app_routes.dart", "w") as f:
    f.write(content)
