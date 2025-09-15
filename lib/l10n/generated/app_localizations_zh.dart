
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get ok => '好的';

  @override
  String get yes => '是的';

  @override
  String get cancel => '取消';

  @override
  String get appTitle => 'Markdown 编辑器';

  @override
  String get previewToolTip => '预览';

  @override
  String get switchThemeMenuItem => '切换主题';

  @override
  String get switchViewMenuItem => '切换视图';

  @override
  String get openFileMenuItem => '打开';

  @override
  String get markdownTextInputLabel => '在此输入你的 Markdown 文本';

  @override
  String get error => '错误';

  @override
  String get unableToOpenFileError => '无法打开文件，请尝试从菜单的打开文件选项中打开它';

  @override
  String get unableToOpenFileFromMenuError => '无法打开文件';

  @override
  String get emptyInputTextContent => '请输入一些文本';

  @override
  String get clear => '清除';

  @override
  String get clearAllTitle => '全部清除';

  @override
  String get clearAllContent => '你确定要清除所有文本吗？';

  @override
  String get saveFileDialogTitle => '输入文件名';

  @override
  String get save => '保存';

  @override
  String get linkDialogTextTitle => '文本';

  @override
  String get linkDialogLinkTitle => '链接';

  @override
  String get enterLinkTextDialogTitle => '输入链接';

  @override
  String get bold => '大胆的';

  @override
  String get italic => '斜体';

  @override
  String get link => '关联';

  @override
  String get image => '图像';

  @override
  String get heading => '标题';

  @override
  String get code => '代码';

  @override
  String get bulletList => '子弹列表';

  @override
  String get quote => '引用';

  @override
  String get horizontalRule => '水平规则';

  @override
  String get strikethrough => '罢工';
}
