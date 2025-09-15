
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get ok => 'Dobře';

  @override
  String get yes => 'Ano';

  @override
  String get cancel => 'Zrušit';

  @override
  String get appTitle => 'Markdown editor';

  @override
  String get previewToolTip => 'Náhled';

  @override
  String get switchThemeMenuItem => 'Přepínač';

  @override
  String get switchViewMenuItem => 'Přepínač';

  @override
  String get openFileMenuItem => 'OTEVŘENO';

  @override
  String get markdownTextInputLabel => 'Zadejte svůj text Markdown zde';

  @override
  String get error => 'Chyba';

  @override
  String get unableToOpenFileError =>
      'Nelze otevřít soubor, zkuste jej otevřít z možnosti otevřeného souboru v nabídce';

  @override
  String get unableToOpenFileFromMenuError => 'Nelze otevřít soubor';

  @override
  String get emptyInputTextContent => 'Zadejte prosím nějaký text';

  @override
  String get clear => 'Jasný';

  @override
  String get clearAllTitle => 'Vyčistit vše';

  @override
  String get clearAllContent => 'Jste si jisti, že chcete vyčistit celý text?';

  @override
  String get saveFileDialogTitle => 'Zadejte název souboru';

  @override
  String get save => 'Uložit';

  @override
  String get linkDialogTextTitle => 'Text';

  @override
  String get linkDialogLinkTitle => 'Odkaz';

  @override
  String get enterLinkTextDialogTitle => 'Zadejte odkaz';

  @override
  String get bold => 'Odvážné';

  @override
  String get italic => 'Kurzíva';

  @override
  String get link => 'Odkaz';

  @override
  String get image => 'Obraz';

  @override
  String get heading => 'Záhlaví';

  @override
  String get code => 'Kód';

  @override
  String get bulletList => 'Seznam kulky';

  @override
  String get quote => 'Citovat';

  @override
  String get horizontalRule => 'Horizontální pravidlo';

  @override
  String get strikethrough => 'Strikethrough';
}
