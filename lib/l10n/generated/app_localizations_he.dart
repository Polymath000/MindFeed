
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get ok => 'בְּסֵדֶר';

  @override
  String get yes => 'כֵּן';

  @override
  String get cancel => 'לְבַטֵל';

  @override
  String get appTitle => 'עורך Markdown';

  @override
  String get previewToolTip => 'תצוגה מקדימה';

  @override
  String get switchThemeMenuItem => 'נושא נושא';

  @override
  String get switchViewMenuItem => 'תצוגה מתג';

  @override
  String get openFileMenuItem => 'לִפְתוֹחַ';

  @override
  String get markdownTextInputLabel => 'הזן את הטקסט שלך ב- Markdown כאן';

  @override
  String get error => 'שְׁגִיאָה';

  @override
  String get unableToOpenFileError =>
      'לא ניתן לפתוח את הקובץ, נסה לפתוח אותו מאפשרות קובץ פתוח בתפריט';

  @override
  String get unableToOpenFileFromMenuError => 'לא ניתן לפתוח את הקובץ';

  @override
  String get emptyInputTextContent => 'אנא הכנס טקסט כלשהו';

  @override
  String get clear => 'בָּרוּר';

  @override
  String get clearAllTitle => 'לנקות הכל';

  @override
  String get clearAllContent => 'האם אתה בטוח שאתה רוצה לנקות את כל הטקסט?';

  @override
  String get saveFileDialogTitle => 'הזן את שם הקובץ';

  @override
  String get save => 'לְהַצִיל';

  @override
  String get linkDialogTextTitle => 'טֶקסט';

  @override
  String get linkDialogLinkTitle => 'לְקַשֵׁר';

  @override
  String get enterLinkTextDialogTitle => 'הזן קישור';

  @override
  String get bold => 'נוֹעָז';

  @override
  String get italic => 'נטוי';

  @override
  String get link => 'לְקַשֵׁר';

  @override
  String get image => 'תְמוּנָה';

  @override
  String get heading => 'כּוֹתֶרֶת';

  @override
  String get code => 'קוד';

  @override
  String get bulletList => 'רשימת כדורים';

  @override
  String get quote => 'לְצַטֵט';

  @override
  String get horizontalRule => 'כלל אופקי';

  @override
  String get strikethrough => 'Strikethrough';
}
