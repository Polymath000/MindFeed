
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

  @override
  String get ok => 'U redu';

  @override
  String get yes => 'Da';

  @override
  String get cancel => 'Otkazati';

  @override
  String get appTitle => 'Uređivač Markdown';

  @override
  String get previewToolTip => 'Pregled';

  @override
  String get switchThemeMenuItem => 'Prebaci temu';

  @override
  String get switchViewMenuItem => 'Preklopnik';

  @override
  String get openFileMenuItem => 'Otvoriti';

  @override
  String get markdownTextInputLabel => 'Unesite svoj tekst Markdown ovdje';

  @override
  String get error => 'Pogreška';

  @override
  String get unableToOpenFileError =>
      'Nije moguće otvoriti datoteku, pokušajte je otvoriti iz opcije otvorene datoteke na izborniku';

  @override
  String get unableToOpenFileFromMenuError => 'Nije moguće otvoriti datoteku';

  @override
  String get emptyInputTextContent => 'Unesite neki tekst';

  @override
  String get clear => 'Jasan';

  @override
  String get clearAllTitle => 'Očisti sve';

  @override
  String get clearAllContent =>
      'Jeste li sigurni želite li očistiti sav tekst?';

  @override
  String get saveFileDialogTitle => 'Unesite ime datoteke';

  @override
  String get save => 'Uštedjeti';

  @override
  String get linkDialogTextTitle => 'Tekst';

  @override
  String get linkDialogLinkTitle => 'Link';

  @override
  String get enterLinkTextDialogTitle => 'Unesite vezu';

  @override
  String get bold => 'Hrabar';

  @override
  String get italic => 'Kurziv';

  @override
  String get link => 'Link';

  @override
  String get image => 'Slika';

  @override
  String get heading => 'Naslov';

  @override
  String get code => 'Kodirati';

  @override
  String get bulletList => 'Popis metaka';

  @override
  String get quote => 'Citat';

  @override
  String get horizontalRule => 'Horizontalno pravilo';

  @override
  String get strikethrough => 'Udar';
}
