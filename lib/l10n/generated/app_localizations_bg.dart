
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bulgarian (`bg`).
class AppLocalizationsBg extends AppLocalizations {
  AppLocalizationsBg([String locale = 'bg']) : super(locale);

  @override
  String get ok => 'Добре';

  @override
  String get yes => 'Да';

  @override
  String get cancel => 'Отказ';

  @override
  String get appTitle => 'Редактор на Markdown';

  @override
  String get previewToolTip => 'Визуализация';

  @override
  String get switchThemeMenuItem => 'Тема за превключване';

  @override
  String get switchViewMenuItem => 'Изглед на превключване';

  @override
  String get openFileMenuItem => 'Отворен';

  @override
  String get markdownTextInputLabel => 'Въведете вашия текст за маркиране тук';

  @override
  String get error => 'Грешка';

  @override
  String get unableToOpenFileError =>
      'Не можете да отворите файла, опитайте да го отворите от опцията Open File в менюто';

  @override
  String get unableToOpenFileFromMenuError => 'Не може да се отвори файла';

  @override
  String get emptyInputTextContent => 'Моля, въведете някакъв текст';

  @override
  String get clear => 'Ясно';

  @override
  String get clearAllTitle => 'Изчистете всички';

  @override
  String get clearAllContent =>
      'Сигурни ли сте, че искате ли да изчистите целия текст?';

  @override
  String get saveFileDialogTitle => 'Въведете името на файла';

  @override
  String get save => 'Запазете';

  @override
  String get linkDialogTextTitle => 'Текст';

  @override
  String get linkDialogLinkTitle => 'Връзка';

  @override
  String get enterLinkTextDialogTitle => 'Въведете връзка';

  @override
  String get bold => 'Смел';

  @override
  String get italic => 'Курсив';

  @override
  String get link => 'Връзка';

  @override
  String get image => 'Изображение';

  @override
  String get heading => 'Заглавие';

  @override
  String get code => 'Код';

  @override
  String get bulletList => 'Списък с куршуми';

  @override
  String get quote => 'Цитат';

  @override
  String get horizontalRule => 'Хоризонтално правило';

  @override
  String get strikethrough => 'Strikethrough';
}
