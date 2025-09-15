
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get ok => 'Rendben';

  @override
  String get yes => 'Igen';

  @override
  String get cancel => 'Töröl';

  @override
  String get appTitle => 'Markdown -szerkesztő';

  @override
  String get previewToolTip => 'Előnézet';

  @override
  String get switchThemeMenuItem => 'Kapcsoló téma';

  @override
  String get switchViewMenuItem => 'Kapcsoló nézet';

  @override
  String get openFileMenuItem => 'Nyitott';

  @override
  String get markdownTextInputLabel => 'Írja be a markdown szöveget ide';

  @override
  String get error => 'Hiba';

  @override
  String get unableToOpenFileError =>
      'Nem sikerült megnyitni a fájlt, próbálja meg megnyitni azt a menü Open File opcióból';

  @override
  String get unableToOpenFileFromMenuError => 'Képtelen megnyitni a fájlt';

  @override
  String get emptyInputTextContent => 'Kérjük, írjon be néhány szöveget';

  @override
  String get clear => 'Világos';

  @override
  String get clearAllTitle => 'Tisztítsa meg az összeset';

  @override
  String get clearAllContent => 'Biztosan szeretné törölni az összes szöveget?';

  @override
  String get saveFileDialogTitle => 'Írja be a fájl nevét';

  @override
  String get save => 'Megtakarítás';

  @override
  String get linkDialogTextTitle => 'Szöveg';

  @override
  String get linkDialogLinkTitle => 'Link';

  @override
  String get enterLinkTextDialogTitle => 'Írja be a linket';

  @override
  String get bold => 'Bátor';

  @override
  String get italic => 'Dőlt betű';

  @override
  String get link => 'Link';

  @override
  String get image => 'Kép';

  @override
  String get heading => 'Cím';

  @override
  String get code => 'Kód';

  @override
  String get bulletList => 'Golyó lista';

  @override
  String get quote => 'Idézet';

  @override
  String get horizontalRule => 'Horizontális szabály';

  @override
  String get strikethrough => 'Robbantás';
}
