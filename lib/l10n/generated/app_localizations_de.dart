
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Ja';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get appTitle => 'Markdown-Editor';

  @override
  String get previewToolTip => 'Vorschau';

  @override
  String get switchThemeMenuItem => 'Thema umschalten';

  @override
  String get switchViewMenuItem => 'Ansicht umschalten';

  @override
  String get openFileMenuItem => 'Datei öffnen';

  @override
  String get markdownTextInputLabel =>
      'Geben Sie hier Ihren Text mit Markdown-Formatierung ein.';

  @override
  String get error => 'Fehler';

  @override
  String get unableToOpenFileError =>
      'Die Datei kann nicht geöffnet werden. Versuchen Sie die Datei via Menü zu öffnen.';

  @override
  String get unableToOpenFileFromMenuError =>
      'Die Datei kann nicht geöffnet werden.';

  @override
  String get emptyInputTextContent => 'Bitte geben Sie einen Text ein.';

  @override
  String get clear => 'Löschen';

  @override
  String get clearAllTitle => 'Alles löschen';

  @override
  String get clearAllContent =>
      'Sind Sie sicher, dass Sie den gesamten Text löschen möchten?';

  @override
  String get saveFileDialogTitle => 'Geben Sie den Namen der Datei ein.';

  @override
  String get save => 'Speichern';

  @override
  String get linkDialogTextTitle => 'Text';

  @override
  String get linkDialogLinkTitle => 'Link';

  @override
  String get enterLinkTextDialogTitle => 'Link einfügen';

  @override
  String get bold => 'Fett';

  @override
  String get italic => 'Kursiv';

  @override
  String get link => 'Link';

  @override
  String get image => 'Bild';

  @override
  String get heading => 'Überschrift';

  @override
  String get code => 'Code';

  @override
  String get bulletList => 'Ungeordnete Liste';

  @override
  String get quote => 'Zitat';

  @override
  String get horizontalRule => 'Horizontale Linie';

  @override
  String get strikethrough => 'Durchgestrichen';
}
