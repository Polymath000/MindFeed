
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Tak';

  @override
  String get cancel => 'Anulować';

  @override
  String get appTitle => 'Edytor Markdown';

  @override
  String get previewToolTip => 'Zapowiedź';

  @override
  String get switchThemeMenuItem => 'Przełącz motyw';

  @override
  String get switchViewMenuItem => 'Widok przełącznika';

  @override
  String get openFileMenuItem => 'Otwarte';

  @override
  String get markdownTextInputLabel => 'Wprowadź swój tekst Markdown tutaj';

  @override
  String get error => 'Błąd';

  @override
  String get unableToOpenFileError =>
      'Nie można otworzyć pliku, spróbuj otworzyć go z opcji Otwórz plik w menu';

  @override
  String get unableToOpenFileFromMenuError => 'Nie można otworzyć pliku';

  @override
  String get emptyInputTextContent => 'Wprowadź tekst';

  @override
  String get clear => 'Jasne';

  @override
  String get clearAllTitle => 'Wyczyść wszystko';

  @override
  String get clearAllContent => 'Czy na pewno chcesz wyczyścić cały tekst?';

  @override
  String get saveFileDialogTitle => 'Wprowadź nazwę pliku';

  @override
  String get save => 'Ratować';

  @override
  String get linkDialogTextTitle => 'Tekst';

  @override
  String get linkDialogLinkTitle => 'Połączyć';

  @override
  String get enterLinkTextDialogTitle => 'Wprowadź link';

  @override
  String get bold => 'Pogrubiony';

  @override
  String get italic => 'italski';

  @override
  String get link => 'Połączyć';

  @override
  String get image => 'Obraz';

  @override
  String get heading => 'Nagłówek';

  @override
  String get code => 'Kod';

  @override
  String get bulletList => 'Lista pocisków';

  @override
  String get quote => 'Cytat';

  @override
  String get horizontalRule => 'Reguła pozioma';

  @override
  String get strikethrough => 'Strikethrough';
}
