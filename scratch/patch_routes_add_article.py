import re
with open("lib/config/routes/app_routes.dart", "r") as f:
    content = f.read()

content = content.replace(
    "return MaterialPageRoute(builder: (_) => AddArticleView(), settings: settings);",
    "return MaterialPageRoute(builder: (_) => BlocProvider(create: (_) => AddArticleCubit(), child: AddArticleView()), settings: settings);"
)

if "import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/add_article_cubit.dart';" not in content:
    content = "import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/add_article_cubit.dart';\n" + content

with open("lib/config/routes/app_routes.dart", "w") as f:
    f.write(content)
