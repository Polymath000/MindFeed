
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Georgian (`ka`).
class AppLocalizationsKa extends AppLocalizations {
  AppLocalizationsKa([String locale = 'ka']) : super(locale);

  @override
  String get ok => 'კარგი';

  @override
  String get yes => 'დიახ';

  @override
  String get cancel => 'გაუქმება';

  @override
  String get appTitle => 'Markdown რედაქტორი';

  @override
  String get previewToolTip => 'ანონსი';

  @override
  String get switchThemeMenuItem => 'შეცვლის თემა';

  @override
  String get switchViewMenuItem => 'შეცვლის ხედი';

  @override
  String get openFileMenuItem => 'გახსნა';

  @override
  String get markdownTextInputLabel => 'შეიყვანეთ თქვენი Markdown ტექსტი აქ';

  @override
  String get error => 'შეცდომა';

  @override
  String get unableToOpenFileError =>
      'ფაილის გახსნა შეუძლებელია, სცადეთ გახსენით იგი მენიუში ღია ფაილის პარამეტრიდან';

  @override
  String get unableToOpenFileFromMenuError => 'ფაილის გახსნა შეუძლებელია';

  @override
  String get emptyInputTextContent => 'გთხოვთ, შეიყვანოთ რამდენიმე ტექსტი';

  @override
  String get clear => 'გასუფთავება';

  @override
  String get clearAllTitle => 'გასუფთავება';

  @override
  String get clearAllContent =>
      'დარწმუნებული ხართ, რომ გსურთ ყველა ტექსტის გასუფთავება?';

  @override
  String get saveFileDialogTitle => 'შეიყვანეთ ფაილის სახელი';

  @override
  String get save => 'გადარჩენა';

  @override
  String get linkDialogTextTitle => 'ტექსტი';

  @override
  String get linkDialogLinkTitle => 'ბმული';

  @override
  String get enterLinkTextDialogTitle => 'შეიყვანეთ ბმული';

  @override
  String get bold => 'გაბედული';

  @override
  String get italic => 'იტალიური';

  @override
  String get link => 'ბმული';

  @override
  String get image => 'გამოსახულება';

  @override
  String get heading => 'სათაური';

  @override
  String get code => 'კოდი';

  @override
  String get bulletList => 'ტყვიების სია';

  @override
  String get quote => 'ციტატის მოყვანა';

  @override
  String get horizontalRule => 'ჰორიზონტალური წესი';

  @override
  String get strikethrough => 'გაფიცვა';
}
