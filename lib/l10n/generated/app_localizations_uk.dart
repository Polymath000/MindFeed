
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get ok => 'Добре';

  @override
  String get yes => 'Так';

  @override
  String get cancel => 'Скасувати';

  @override
  String get appTitle => 'Редактор Markdown';

  @override
  String get previewToolTip => 'Попередній перегляд';

  @override
  String get switchThemeMenuItem => 'Тема перемикання';

  @override
  String get switchViewMenuItem => 'Перегляд перемикання';

  @override
  String get openFileMenuItem => 'ВІДЧИНЕНО';

  @override
  String get markdownTextInputLabel => 'Введіть тут свій текст на відміток';

  @override
  String get error => 'Помилка';

  @override
  String get unableToOpenFileError =>
      'Неможливо відкрити файл, спробуйте відкрити його з опції Open File у меню';

  @override
  String get unableToOpenFileFromMenuError => 'Неможливо відкрити файл';

  @override
  String get emptyInputTextContent => 'Введіть трохи тексту';

  @override
  String get clear => 'Чіткий';

  @override
  String get clearAllTitle => 'Очистити все';

  @override
  String get clearAllContent => 'Ви впевнені, що хочете очистити весь текст?';

  @override
  String get saveFileDialogTitle => 'Введіть ім\'я файлу';

  @override
  String get save => 'Заощадити';

  @override
  String get linkDialogTextTitle => 'Текст';

  @override
  String get linkDialogLinkTitle => 'Зв\'язок';

  @override
  String get enterLinkTextDialogTitle => 'Введіть посилання';

  @override
  String get bold => 'Сміливий';

  @override
  String get italic => 'Курсив';

  @override
  String get link => 'Зв\'язок';

  @override
  String get image => 'Зображення';

  @override
  String get heading => 'Заголовок';

  @override
  String get code => 'Кодування';

  @override
  String get bulletList => 'Список кулі';

  @override
  String get quote => 'Цитата';

  @override
  String get horizontalRule => 'Горизонтальне правило';

  @override
  String get strikethrough => 'Вражати';
}
