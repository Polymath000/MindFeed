
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get ok => 'ตกลง';

  @override
  String get yes => 'ใช่';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get appTitle => 'ตัวแก้ไข Markdown';

  @override
  String get previewToolTip => 'ดูตัวอย่าง';

  @override
  String get switchThemeMenuItem => 'เปลี่ยนธีม';

  @override
  String get switchViewMenuItem => 'เปลี่ยนมุมมอง';

  @override
  String get openFileMenuItem => 'เปิด';

  @override
  String get markdownTextInputLabel => 'ป้อนข้อความ Markdown ของคุณที่นี่';

  @override
  String get error => 'ข้อผิดพลาด';

  @override
  String get unableToOpenFileError =>
      'ไม่สามารถเปิดไฟล์ได้ลองเปิดจากตัวเลือกเปิดไฟล์บนเมนู';

  @override
  String get unableToOpenFileFromMenuError => 'ไม่สามารถเปิดไฟล์ได้';

  @override
  String get emptyInputTextContent => 'กรุณากรอกข้อความ';

  @override
  String get clear => 'ชัดเจน';

  @override
  String get clearAllTitle => 'ล้างทั้งหมด';

  @override
  String get clearAllContent =>
      'คุณแน่ใจหรือไม่ว่าคุณต้องการล้างข้อความทั้งหมดหรือไม่?';

  @override
  String get saveFileDialogTitle => 'ป้อนชื่อไฟล์';

  @override
  String get save => 'บันทึก';

  @override
  String get linkDialogTextTitle => 'ข้อความ';

  @override
  String get linkDialogLinkTitle => 'การเชื่อมโยง';

  @override
  String get enterLinkTextDialogTitle => 'ป้อนลิงค์';

  @override
  String get bold => 'ตัวหนา';

  @override
  String get italic => 'ตัวเอียง';

  @override
  String get link => 'การเชื่อมโยง';

  @override
  String get image => 'ภาพ';

  @override
  String get heading => 'หัวเรื่อง';

  @override
  String get code => 'รหัส';

  @override
  String get bulletList => 'รายการกระสุนปืน';

  @override
  String get quote => 'อ้าง';

  @override
  String get horizontalRule => 'กฎแนวนอน';

  @override
  String get strikethrough => 'สเตจ';
}
