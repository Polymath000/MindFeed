
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get ok => 'Хорошо';

  @override
  String get yes => 'Да';

  @override
  String get cancel => 'Отмена';

  @override
  String get appTitle => 'Редактор Markdown';

  @override
  String get previewToolTip => 'Предварительный просмотр';

  @override
  String get switchThemeMenuItem => 'Переключить тему';

  @override
  String get switchViewMenuItem => 'Переключить вид';

  @override
  String get openFileMenuItem => 'Открыть';

  @override
  String get markdownTextInputLabel => 'Введите здесь свой текст разметки';

  @override
  String get error => 'Ошибка';

  @override
  String get unableToOpenFileError =>
      'Невозможно открыть файл, попробуйте открыть его из опции Open File в меню';

  @override
  String get unableToOpenFileFromMenuError => 'Невозможно открыть файл';

  @override
  String get emptyInputTextContent => 'Пожалуйста, введите немного текста';

  @override
  String get clear => 'Прозрачный';

  @override
  String get clearAllTitle => 'Очистить все';

  @override
  String get clearAllContent => 'Вы уверены, что хотите очистить весь текст?';

  @override
  String get saveFileDialogTitle => 'Введите имя файла';

  @override
  String get save => 'Сохранять';

  @override
  String get linkDialogTextTitle => 'Текст';

  @override
  String get linkDialogLinkTitle => 'Связь';

  @override
  String get enterLinkTextDialogTitle => 'Введите ссылку';

  @override
  String get bold => 'Смелый';

  @override
  String get italic => 'Курсив';

  @override
  String get link => 'Связь';

  @override
  String get image => 'Изображение';

  @override
  String get heading => 'Заголовок';

  @override
  String get code => 'Код';

  @override
  String get bulletList => 'Список пуль';

  @override
  String get quote => 'Цитировать';

  @override
  String get horizontalRule => 'Горизонтальное правило';

  @override
  String get strikethrough => 'Удар';
}
