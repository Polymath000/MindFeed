import re

with open("lib/features/add_article/presentation/views/home_of_add_article_view.dart", "r") as f:
    content = f.read()

# Add imports
if "import 'package:flutter_bloc/flutter_bloc.dart';" not in content:
    content = "import 'package:flutter_bloc/flutter_bloc.dart';\n" + content
if "import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/add_article_cubit.dart';" not in content:
    content = "import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/add_article_cubit.dart';\n" + content


# Remove _openFilePicker method body and use cubit
content = re.sub(
    r"Future<void> _openFilePicker\(\) async \{.*?\n  \}",
    """Future<void> _openFilePicker() async {
    context.read<AddArticleCubit>().openFile();
  }""",
    content,
    flags=re.DOTALL
)

# Remove _saveFile method body and use cubit
content = re.sub(
    r"Future<void> _saveFile\(\) async \{.*?\n  \}",
    """Future<void> _saveFile() async {
    context.read<AddArticleCubit>().saveFile(_inputText);
  }""",
    content,
    flags=re.DOTALL
)

# Fix _clearText logic
content = re.sub(
    r"Future<void> _clearText\(\) async \{.*?TextButton\(\n\s*onPressed: \(\) \{\n\s*setState\(\(\) \{\n\s*_inputText = \"\";\n\s*_textEditingController\.clear\(\);\n\s*\}\);\n\s*Navigator\.pop\(context\);\n\s*\}.*?\n  \}",
    """Future<void> _clearText() async {
    if (_inputText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.emptyInputTextContent),
        ),
      );
      return;
    }
    FocusScope.of(context).unfocus();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.clearAllTitle),
        content: Text(AppLocalizations.of(context)!.clearAllContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              context.read<AddArticleCubit>().clearText();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.yes),
          ),
        ],
      ),
    );
  }""",
    content,
    flags=re.DOTALL
)

# Wrap Scaffold body with BlocConsumer
content = re.sub(
    r"body: _isLoading.*?_fullView\(\),\n",
    """body: BlocConsumer<AddArticleCubit, AddArticleState>(
          listener: (context, state) {
            if (state is AddArticleError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is AddArticleFileLoaded) {
              _inputText = state.content;
              _textEditingController.text = state.content;
            }
          },
          builder: (context, state) {
            if (state is AddArticleLoading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            return (widget.devicePreferenceNotifier.value.isSplitLayout)
                ? _splitView()
                : _fullView();
          },
        ),
""",
    content,
    flags=re.DOTALL
)

with open("lib/features/add_article/presentation/views/home_of_add_article_view.dart", "w") as f:
    f.write(content)
