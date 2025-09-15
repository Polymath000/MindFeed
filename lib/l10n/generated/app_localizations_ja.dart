
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get ok => 'わかりました';

  @override
  String get yes => 'はい';

  @override
  String get cancel => 'キャンセル';

  @override
  String get appTitle => 'マークダウンエディター';

  @override
  String get previewToolTip => 'プレビュー';

  @override
  String get switchThemeMenuItem => 'テーマを切り替えます';

  @override
  String get switchViewMenuItem => 'スイッチビュー';

  @override
  String get openFileMenuItem => '開ける';

  @override
  String get markdownTextInputLabel => 'ここにマークダウンテキストを入力してください';

  @override
  String get error => 'エラー';

  @override
  String get unableToOpenFileError =>
      'ファイルを開くことができない場合は、メニューの[ファイル]オプションから開いてみてください';

  @override
  String get unableToOpenFileFromMenuError => 'ファイルを開くことができません';

  @override
  String get emptyInputTextContent => 'テキストを入力してください';

  @override
  String get clear => 'クリア';

  @override
  String get clearAllTitle => 'すべてをクリアします';

  @override
  String get clearAllContent => 'すべてのテキストをクリアしたいですか？';

  @override
  String get saveFileDialogTitle => 'ファイルの名前を入力します';

  @override
  String get save => '保存';

  @override
  String get linkDialogTextTitle => '文章';

  @override
  String get linkDialogLinkTitle => 'リンク';

  @override
  String get enterLinkTextDialogTitle => 'リンクを入力します';

  @override
  String get bold => '大胆な';

  @override
  String get italic => 'イタリック';

  @override
  String get link => 'リンク';

  @override
  String get image => '画像';

  @override
  String get heading => '見出し';

  @override
  String get code => 'コード';

  @override
  String get bulletList => '弾丸リスト';

  @override
  String get quote => '引用';

  @override
  String get horizontalRule => '水平ルール';

  @override
  String get strikethrough => 'strikethrough';
}
