import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;
import 'app_localizations_ace.dart';
import 'app_localizations_ach.dart';
import 'app_localizations_af.dart';
import 'app_localizations_ak.dart';
import 'app_localizations_alz.dart';
import 'app_localizations_am.dart';
import 'app_localizations_ar.dart';
import 'app_localizations_as.dart';
import 'app_localizations_awa.dart';
import 'app_localizations_ay.dart';
import 'app_localizations_az.dart';
import 'app_localizations_bal.dart';
import 'app_localizations_ban.dart';
import 'app_localizations_bbc.dart';
import 'app_localizations_bci.dart';
import 'app_localizations_be.dart';
import 'app_localizations_bem.dart';
import 'app_localizations_ber.dart';
import 'app_localizations_bew.dart';
import 'app_localizations_bg.dart';
import 'app_localizations_bho.dart';
import 'app_localizations_bik.dart';
import 'app_localizations_bm.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_bs.dart';
import 'app_localizations_bts.dart';
import 'app_localizations_btx.dart';
import 'app_localizations_bua.dart';
import 'app_localizations_ca.dart';
import 'app_localizations_ceb.dart';
import 'app_localizations_cgg.dart';
import 'app_localizations_chk.dart';
import 'app_localizations_ckb.dart';
import 'app_localizations_cnh.dart';
import 'app_localizations_co.dart';
import 'app_localizations_crh.dart';
import 'app_localizations_crs.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_cy.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_din.dart';
import 'app_localizations_doi.dart';
import 'app_localizations_dv.dart';
import 'app_localizations_dyu.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_eo.dart';
import 'app_localizations_es.dart';
import 'app_localizations_et.dart';
import 'app_localizations_eu.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fil.dart';
import 'app_localizations_fon.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_fur.dart';
import 'app_localizations_fy.dart';
import 'app_localizations_ga.dart';
import 'app_localizations_gaa.dart';
import 'app_localizations_gd.dart';
import 'app_localizations_gl.dart';
import 'app_localizations_gn.dart';
import 'app_localizations_gom.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_ha.dart';
import 'app_localizations_haw.dart';
import 'app_localizations_he.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hil.dart';
import 'app_localizations_hmn.dart';
import 'app_localizations_hr.dart';
import 'app_localizations_hrx.dart';
import 'app_localizations_ht.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_hy.dart';
import 'app_localizations_iba.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ig.dart';
import 'app_localizations_ilo.dart';
import 'app_localizations_is.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_jam.dart';
import 'app_localizations_jv.dart';
import 'app_localizations_ka.dart';
import 'app_localizations_kac.dart';
import 'app_localizations_kek.dart';
import 'app_localizations_kha.dart';
import 'app_localizations_kk.dart';
import 'app_localizations_km.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_kri.dart';
import 'app_localizations_ktu.dart';
import 'app_localizations_ku.dart';
import 'app_localizations_ky.dart';
import 'app_localizations_la.dart';
import 'app_localizations_lb.dart';
import 'app_localizations_lg.dart';
import 'app_localizations_lij.dart';
import 'app_localizations_lmo.dart';
import 'app_localizations_ln.dart';
import 'app_localizations_lo.dart';
import 'app_localizations_lt.dart';
import 'app_localizations_ltg.dart';
import 'app_localizations_luo.dart';
import 'app_localizations_lus.dart';
import 'app_localizations_lv.dart';
import 'app_localizations_mai.dart';
import 'app_localizations_mak.dart';
import 'app_localizations_mam.dart';
import 'app_localizations_mfe.dart';
import 'app_localizations_mg.dart';
import 'app_localizations_mhr.dart';
import 'app_localizations_mi.dart';
import 'app_localizations_min.dart';
import 'app_localizations_mk.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mn.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_mt.dart';
import 'app_localizations_mwr.dart';
import 'app_localizations_my.dart';
import 'app_localizations_ne.dart';
import 'app_localizations_new.dart';
import 'app_localizations_nhe.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_no.dart';
import 'app_localizations_nso.dart';
import 'app_localizations_nus.dart';
import 'app_localizations_ny.dart';
import 'app_localizations_om.dart';
import 'app_localizations_or.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_pag.dart';
import 'app_localizations_pam.dart';
import 'app_localizations_pap.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_ps.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_qu.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_rom.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_rw.dart';
import 'app_localizations_sa.dart';
import 'app_localizations_sah.dart';
import 'app_localizations_sat.dart';
import 'app_localizations_scn.dart';
import 'app_localizations_sd.dart';
import 'app_localizations_shn.dart';
import 'app_localizations_si.dart';
import 'app_localizations_sk.dart';
import 'app_localizations_sl.dart';
import 'app_localizations_sm.dart';
import 'app_localizations_sn.dart';
import 'app_localizations_so.dart';
import 'app_localizations_sq.dart';
import 'app_localizations_sr.dart';
import 'app_localizations_st.dart';
import 'app_localizations_su.dart';
import 'app_localizations_sus.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_sw.dart';
import 'app_localizations_szl.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';
import 'app_localizations_tet.dart';
import 'app_localizations_tg.dart';
import 'app_localizations_th.dart';
import 'app_localizations_ti.dart';
import 'app_localizations_tiv.dart';
import 'app_localizations_tk.dart';
import 'app_localizations_tl.dart';
import 'app_localizations_tpi.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_ts.dart';
import 'app_localizations_tt.dart';
import 'app_localizations_tum.dart';
import 'app_localizations_udm.dart';
import 'app_localizations_ug.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_uz.dart';
import 'app_localizations_vec.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_war.dart';
import 'app_localizations_xh.dart';
import 'app_localizations_yi.dart';
import 'app_localizations_yo.dart';
import 'app_localizations_yua.dart';
import 'app_localizations_yue.dart';
import 'app_localizations_zap.dart';
import 'app_localizations_zh.dart';
import 'app_localizations_zu.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ace'),
    Locale('ach'),
    Locale('af'),
    Locale('ak'),
    Locale('alz'),
    Locale('am'),
    Locale('ar'),
    Locale('as'),
    Locale('awa'),
    Locale('ay'),
    Locale('az'),
    Locale('bal'),
    Locale('ban'),
    Locale('bbc'),
    Locale('bci'),
    Locale('be'),
    Locale('bem'),
    Locale('ber'),
    Locale('bew'),
    Locale('bg'),
    Locale('bho'),
    Locale('bik'),
    Locale('bm'),
    Locale('bn'),
    Locale('bs'),
    Locale('bts'),
    Locale('btx'),
    Locale('bua'),
    Locale('ca'),
    Locale('ceb'),
    Locale('cgg'),
    Locale('chk'),
    Locale('ckb'),
    Locale('cnh'),
    Locale('co'),
    Locale('crh'),
    Locale('crs'),
    Locale('cs'),
    Locale('cy'),
    Locale('da'),
    Locale('de'),
    Locale('din'),
    Locale('doi'),
    Locale('dv'),
    Locale('dyu'),
    Locale('el'),
    Locale('en'),
    Locale('eo'),
    Locale('es'),
    Locale('et'),
    Locale('eu'),
    Locale('fa'),
    Locale('fi'),
    Locale('fil'),
    Locale('fon'),
    Locale('fr'),
    Locale('fur'),
    Locale('fy'),
    Locale('ga'),
    Locale('gaa'),
    Locale('gd'),
    Locale('gl'),
    Locale('gn'),
    Locale('gom'),
    Locale('gu'),
    Locale('ha'),
    Locale('haw'),
    Locale('he'),
    Locale('hi'),
    Locale('hil'),
    Locale('hmn'),
    Locale('hr'),
    Locale('hrx'),
    Locale('ht'),
    Locale('hu'),
    Locale('hy'),
    Locale('iba'),
    Locale('id'),
    Locale('ig'),
    Locale('ilo'),
    Locale('is'),
    Locale('it'),
    Locale('ja'),
    Locale('jam'),
    Locale('jv'),
    Locale('ka'),
    Locale('kac'),
    Locale('kek'),
    Locale('kha'),
    Locale('kk'),
    Locale('km'),
    Locale('kn'),
    Locale('ko'),
    Locale('kri'),
    Locale('ktu'),
    Locale('ku'),
    Locale('ky'),
    Locale('la'),
    Locale('lb'),
    Locale('lg'),
    Locale('lij'),
    Locale('lmo'),
    Locale('ln'),
    Locale('lo'),
    Locale('lt'),
    Locale('ltg'),
    Locale('luo'),
    Locale('lus'),
    Locale('lv'),
    Locale('mai'),
    Locale('mak'),
    Locale('mam'),
    Locale('mfe'),
    Locale('mg'),
    Locale('mhr'),
    Locale('mi'),
    Locale('min'),
    Locale('mk'),
    Locale('ml'),
    Locale('mn'),
    Locale('mr'),
    Locale('ms'),
    Locale('mt'),
    Locale('mwr'),
    Locale('my'),
    Locale('ne'),
    Locale('new'),
    Locale('nhe'),
    Locale('nl'),
    Locale('no'),
    Locale('nso'),
    Locale('nus'),
    Locale('ny'),
    Locale('om'),
    Locale('or'),
    Locale('pa'),
    Locale('pag'),
    Locale('pam'),
    Locale('pap'),
    Locale('pl'),
    Locale('ps'),
    Locale('pt'),
    Locale('qu'),
    Locale('ro'),
    Locale('rom'),
    Locale('ru'),
    Locale('rw'),
    Locale('sa'),
    Locale('sah'),
    Locale('sat'),
    Locale('scn'),
    Locale('sd'),
    Locale('shn'),
    Locale('si'),
    Locale('sk'),
    Locale('sl'),
    Locale('sm'),
    Locale('sn'),
    Locale('so'),
    Locale('sq'),
    Locale('sr'),
    Locale('st'),
    Locale('su'),
    Locale('sus'),
    Locale('sv'),
    Locale('sw'),
    Locale('szl'),
    Locale('ta'),
    Locale('te'),
    Locale('tet'),
    Locale('tg'),
    Locale('th'),
    Locale('ti'),
    Locale('tiv'),
    Locale('tk'),
    Locale('tl'),
    Locale('tpi'),
    Locale('tr'),
    Locale('ts'),
    Locale('tt'),
    Locale('tum'),
    Locale('udm'),
    Locale('ug'),
    Locale('uk'),
    Locale('ur'),
    Locale('uz'),
    Locale('vec'),
    Locale('vi'),
    Locale('war'),
    Locale('xh'),
    Locale('yi'),
    Locale('yo'),
    Locale('yua'),
    Locale('yue'),
    Locale('zap'),
    Locale('zh'),
    Locale('zu'),
  ];

  /// Positive Action for the Alert Dialog
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// Alternate Positive Action for the Alert Dialog
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// Negative Action for the Alert Dialog
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// The Name of the app
  ///
  /// In en, this message translates to:
  /// **'Markdown Editor'**
  String get appTitle;

  /// Tooltip for the Preview Icon Button
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get previewToolTip;

  /// Menu Item of Switch Theme
  ///
  /// In en, this message translates to:
  /// **'Switch Theme'**
  String get switchThemeMenuItem;

  /// Menu Item of Switch View
  ///
  /// In en, this message translates to:
  /// **'Switch View'**
  String get switchViewMenuItem;

  /// Menu Item of Open File
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openFileMenuItem;

  /// InputText Label for the MarkDownTextInput Widget
  ///
  /// In en, this message translates to:
  /// **'Enter your markdown text here'**
  String get markdownTextInputLabel;

  /// Title for the Error Alert Dialog
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Content for the Error Alert Dialog when the file can't be opened
  ///
  /// In en, this message translates to:
  /// **'Unable to open the file, try opening it from open file option on the menu'**
  String get unableToOpenFileError;

  /// Content for the Error Alert Dialog when the file can't be opened from the menu
  ///
  /// In en, this message translates to:
  /// **'Unable to open the file'**
  String get unableToOpenFileFromMenuError;

  /// Content for the SnackBar when input text is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter some text'**
  String get emptyInputTextContent;

  /// Menu Item for Clearing Text
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Title for the Clear All Dialog
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAllTitle;

  /// Content for the Clear All Dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure do you want to clear all the text?'**
  String get clearAllContent;

  /// Title for the Save File Dialog
  ///
  /// In en, this message translates to:
  /// **'Enter the name of the file'**
  String get saveFileDialogTitle;

  /// Positive Action for the Save File Alert Dialog and the Save File Menu Item
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Text Field Title of The Link Dialog Box
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get linkDialogTextTitle;

  /// Link Field Title of The Link Dialog Box
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get linkDialogLinkTitle;

  /// Title for the Enter Link Dialog
  ///
  /// In en, this message translates to:
  /// **'Enter Link'**
  String get enterLinkTextDialogTitle;

  /// Tooltip for the Bold Icon Button
  ///
  /// In en, this message translates to:
  /// **'Bold'**
  String get bold;

  /// Tooltip for the Italic Icon Button
  ///
  /// In en, this message translates to:
  /// **'Italic'**
  String get italic;

  /// Tooltip for the Link Icon Button
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get link;

  /// Tooltip for the Image Icon Button
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get image;

  /// Tooltip for the Heading Icon Button
  ///
  /// In en, this message translates to:
  /// **'Heading'**
  String get heading;

  /// Tooltip for the Code Icon Button
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code;

  /// Tooltip for the Bullet List Icon Button
  ///
  /// In en, this message translates to:
  /// **'Bullet List'**
  String get bulletList;

  /// Tooltip for the Quote Icon Button
  ///
  /// In en, this message translates to:
  /// **'Quote'**
  String get quote;

  /// Tooltip for the Horizontal Rule Icon Button
  ///
  /// In en, this message translates to:
  /// **'Horizontal Rule'**
  String get horizontalRule;

  /// Tooltip for the Strikethrough Icon Button
  ///
  /// In en, this message translates to:
  /// **'Strikethrough'**
  String get strikethrough;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ace',
    'ach',
    'af',
    'ak',
    'alz',
    'am',
    'ar',
    'as',
    'awa',
    'ay',
    'az',
    'bal',
    'ban',
    'bbc',
    'bci',
    'be',
    'bem',
    'ber',
    'bew',
    'bg',
    'bho',
    'bik',
    'bm',
    'bn',
    'bs',
    'bts',
    'btx',
    'bua',
    'ca',
    'ceb',
    'cgg',
    'chk',
    'ckb',
    'cnh',
    'co',
    'crh',
    'crs',
    'cs',
    'cy',
    'da',
    'de',
    'din',
    'doi',
    'dv',
    'dyu',
    'el',
    'en',
    'eo',
    'es',
    'et',
    'eu',
    'fa',
    'fi',
    'fil',
    'fon',
    'fr',
    'fur',
    'fy',
    'ga',
    'gaa',
    'gd',
    'gl',
    'gn',
    'gom',
    'gu',
    'ha',
    'haw',
    'he',
    'hi',
    'hil',
    'hmn',
    'hr',
    'hrx',
    'ht',
    'hu',
    'hy',
    'iba',
    'id',
    'ig',
    'ilo',
    'is',
    'it',
    'ja',
    'jam',
    'jv',
    'ka',
    'kac',
    'kek',
    'kha',
    'kk',
    'km',
    'kn',
    'ko',
    'kri',
    'ktu',
    'ku',
    'ky',
    'la',
    'lb',
    'lg',
    'lij',
    'lmo',
    'ln',
    'lo',
    'lt',
    'ltg',
    'luo',
    'lus',
    'lv',
    'mai',
    'mak',
    'mam',
    'mfe',
    'mg',
    'mhr',
    'mi',
    'min',
    'mk',
    'ml',
    'mn',
    'mr',
    'ms',
    'mt',
    'mwr',
    'my',
    'ne',
    'new',
    'nhe',
    'nl',
    'no',
    'nso',
    'nus',
    'ny',
    'om',
    'or',
    'pa',
    'pag',
    'pam',
    'pap',
    'pl',
    'ps',
    'pt',
    'qu',
    'ro',
    'rom',
    'ru',
    'rw',
    'sa',
    'sah',
    'sat',
    'scn',
    'sd',
    'shn',
    'si',
    'sk',
    'sl',
    'sm',
    'sn',
    'so',
    'sq',
    'sr',
    'st',
    'su',
    'sus',
    'sv',
    'sw',
    'szl',
    'ta',
    'te',
    'tet',
    'tg',
    'th',
    'ti',
    'tiv',
    'tk',
    'tl',
    'tpi',
    'tr',
    'ts',
    'tt',
    'tum',
    'udm',
    'ug',
    'uk',
    'ur',
    'uz',
    'vec',
    'vi',
    'war',
    'xh',
    'yi',
    'yo',
    'yua',
    'yue',
    'zap',
    'zh',
    'zu',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ace':
      return AppLocalizationsAce();
    case 'ach':
      return AppLocalizationsAch();
    case 'af':
      return AppLocalizationsAf();
    case 'ak':
      return AppLocalizationsAk();
    case 'alz':
      return AppLocalizationsAlz();
    case 'am':
      return AppLocalizationsAm();
    case 'ar':
      return AppLocalizationsAr();
    case 'as':
      return AppLocalizationsAs();
    case 'awa':
      return AppLocalizationsAwa();
    case 'ay':
      return AppLocalizationsAy();
    case 'az':
      return AppLocalizationsAz();
    case 'bal':
      return AppLocalizationsBal();
    case 'ban':
      return AppLocalizationsBan();
    case 'bbc':
      return AppLocalizationsBbc();
    case 'bci':
      return AppLocalizationsBci();
    case 'be':
      return AppLocalizationsBe();
    case 'bem':
      return AppLocalizationsBem();
    case 'ber':
      return AppLocalizationsBer();
    case 'bew':
      return AppLocalizationsBew();
    case 'bg':
      return AppLocalizationsBg();
    case 'bho':
      return AppLocalizationsBho();
    case 'bik':
      return AppLocalizationsBik();
    case 'bm':
      return AppLocalizationsBm();
    case 'bn':
      return AppLocalizationsBn();
    case 'bs':
      return AppLocalizationsBs();
    case 'bts':
      return AppLocalizationsBts();
    case 'btx':
      return AppLocalizationsBtx();
    case 'bua':
      return AppLocalizationsBua();
    case 'ca':
      return AppLocalizationsCa();
    case 'ceb':
      return AppLocalizationsCeb();
    case 'cgg':
      return AppLocalizationsCgg();
    case 'chk':
      return AppLocalizationsChk();
    case 'ckb':
      return AppLocalizationsCkb();
    case 'cnh':
      return AppLocalizationsCnh();
    case 'co':
      return AppLocalizationsCo();
    case 'crh':
      return AppLocalizationsCrh();
    case 'crs':
      return AppLocalizationsCrs();
    case 'cs':
      return AppLocalizationsCs();
    case 'cy':
      return AppLocalizationsCy();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'din':
      return AppLocalizationsDin();
    case 'doi':
      return AppLocalizationsDoi();
    case 'dv':
      return AppLocalizationsDv();
    case 'dyu':
      return AppLocalizationsDyu();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'eo':
      return AppLocalizationsEo();
    case 'es':
      return AppLocalizationsEs();
    case 'et':
      return AppLocalizationsEt();
    case 'eu':
      return AppLocalizationsEu();
    case 'fa':
      return AppLocalizationsFa();
    case 'fi':
      return AppLocalizationsFi();
    case 'fil':
      return AppLocalizationsFil();
    case 'fon':
      return AppLocalizationsFon();
    case 'fr':
      return AppLocalizationsFr();
    case 'fur':
      return AppLocalizationsFur();
    case 'fy':
      return AppLocalizationsFy();
    case 'ga':
      return AppLocalizationsGa();
    case 'gaa':
      return AppLocalizationsGaa();
    case 'gd':
      return AppLocalizationsGd();
    case 'gl':
      return AppLocalizationsGl();
    case 'gn':
      return AppLocalizationsGn();
    case 'gom':
      return AppLocalizationsGom();
    case 'gu':
      return AppLocalizationsGu();
    case 'ha':
      return AppLocalizationsHa();
    case 'haw':
      return AppLocalizationsHaw();
    case 'he':
      return AppLocalizationsHe();
    case 'hi':
      return AppLocalizationsHi();
    case 'hil':
      return AppLocalizationsHil();
    case 'hmn':
      return AppLocalizationsHmn();
    case 'hr':
      return AppLocalizationsHr();
    case 'hrx':
      return AppLocalizationsHrx();
    case 'ht':
      return AppLocalizationsHt();
    case 'hu':
      return AppLocalizationsHu();
    case 'hy':
      return AppLocalizationsHy();
    case 'iba':
      return AppLocalizationsIba();
    case 'id':
      return AppLocalizationsId();
    case 'ig':
      return AppLocalizationsIg();
    case 'ilo':
      return AppLocalizationsIlo();
    case 'is':
      return AppLocalizationsIs();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'jam':
      return AppLocalizationsJam();
    case 'jv':
      return AppLocalizationsJv();
    case 'ka':
      return AppLocalizationsKa();
    case 'kac':
      return AppLocalizationsKac();
    case 'kek':
      return AppLocalizationsKek();
    case 'kha':
      return AppLocalizationsKha();
    case 'kk':
      return AppLocalizationsKk();
    case 'km':
      return AppLocalizationsKm();
    case 'kn':
      return AppLocalizationsKn();
    case 'ko':
      return AppLocalizationsKo();
    case 'kri':
      return AppLocalizationsKri();
    case 'ktu':
      return AppLocalizationsKtu();
    case 'ku':
      return AppLocalizationsKu();
    case 'ky':
      return AppLocalizationsKy();
    case 'la':
      return AppLocalizationsLa();
    case 'lb':
      return AppLocalizationsLb();
    case 'lg':
      return AppLocalizationsLg();
    case 'lij':
      return AppLocalizationsLij();
    case 'lmo':
      return AppLocalizationsLmo();
    case 'ln':
      return AppLocalizationsLn();
    case 'lo':
      return AppLocalizationsLo();
    case 'lt':
      return AppLocalizationsLt();
    case 'ltg':
      return AppLocalizationsLtg();
    case 'luo':
      return AppLocalizationsLuo();
    case 'lus':
      return AppLocalizationsLus();
    case 'lv':
      return AppLocalizationsLv();
    case 'mai':
      return AppLocalizationsMai();
    case 'mak':
      return AppLocalizationsMak();
    case 'mam':
      return AppLocalizationsMam();
    case 'mfe':
      return AppLocalizationsMfe();
    case 'mg':
      return AppLocalizationsMg();
    case 'mhr':
      return AppLocalizationsMhr();
    case 'mi':
      return AppLocalizationsMi();
    case 'min':
      return AppLocalizationsMin();
    case 'mk':
      return AppLocalizationsMk();
    case 'ml':
      return AppLocalizationsMl();
    case 'mn':
      return AppLocalizationsMn();
    case 'mr':
      return AppLocalizationsMr();
    case 'ms':
      return AppLocalizationsMs();
    case 'mt':
      return AppLocalizationsMt();
    case 'mwr':
      return AppLocalizationsMwr();
    case 'my':
      return AppLocalizationsMy();
    case 'ne':
      return AppLocalizationsNe();
    case 'new':
      return AppLocalizationsNew();
    case 'nhe':
      return AppLocalizationsNhe();
    case 'nl':
      return AppLocalizationsNl();
    case 'no':
      return AppLocalizationsNo();
    case 'nso':
      return AppLocalizationsNso();
    case 'nus':
      return AppLocalizationsNus();
    case 'ny':
      return AppLocalizationsNy();
    case 'om':
      return AppLocalizationsOm();
    case 'or':
      return AppLocalizationsOr();
    case 'pa':
      return AppLocalizationsPa();
    case 'pag':
      return AppLocalizationsPag();
    case 'pam':
      return AppLocalizationsPam();
    case 'pap':
      return AppLocalizationsPap();
    case 'pl':
      return AppLocalizationsPl();
    case 'ps':
      return AppLocalizationsPs();
    case 'pt':
      return AppLocalizationsPt();
    case 'qu':
      return AppLocalizationsQu();
    case 'ro':
      return AppLocalizationsRo();
    case 'rom':
      return AppLocalizationsRom();
    case 'ru':
      return AppLocalizationsRu();
    case 'rw':
      return AppLocalizationsRw();
    case 'sa':
      return AppLocalizationsSa();
    case 'sah':
      return AppLocalizationsSah();
    case 'sat':
      return AppLocalizationsSat();
    case 'scn':
      return AppLocalizationsScn();
    case 'sd':
      return AppLocalizationsSd();
    case 'shn':
      return AppLocalizationsShn();
    case 'si':
      return AppLocalizationsSi();
    case 'sk':
      return AppLocalizationsSk();
    case 'sl':
      return AppLocalizationsSl();
    case 'sm':
      return AppLocalizationsSm();
    case 'sn':
      return AppLocalizationsSn();
    case 'so':
      return AppLocalizationsSo();
    case 'sq':
      return AppLocalizationsSq();
    case 'sr':
      return AppLocalizationsSr();
    case 'st':
      return AppLocalizationsSt();
    case 'su':
      return AppLocalizationsSu();
    case 'sus':
      return AppLocalizationsSus();
    case 'sv':
      return AppLocalizationsSv();
    case 'sw':
      return AppLocalizationsSw();
    case 'szl':
      return AppLocalizationsSzl();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
    case 'tet':
      return AppLocalizationsTet();
    case 'tg':
      return AppLocalizationsTg();
    case 'th':
      return AppLocalizationsTh();
    case 'ti':
      return AppLocalizationsTi();
    case 'tiv':
      return AppLocalizationsTiv();
    case 'tk':
      return AppLocalizationsTk();
    case 'tl':
      return AppLocalizationsTl();
    case 'tpi':
      return AppLocalizationsTpi();
    case 'tr':
      return AppLocalizationsTr();
    case 'ts':
      return AppLocalizationsTs();
    case 'tt':
      return AppLocalizationsTt();
    case 'tum':
      return AppLocalizationsTum();
    case 'udm':
      return AppLocalizationsUdm();
    case 'ug':
      return AppLocalizationsUg();
    case 'uk':
      return AppLocalizationsUk();
    case 'ur':
      return AppLocalizationsUr();
    case 'uz':
      return AppLocalizationsUz();
    case 'vec':
      return AppLocalizationsVec();
    case 'vi':
      return AppLocalizationsVi();
    case 'war':
      return AppLocalizationsWar();
    case 'xh':
      return AppLocalizationsXh();
    case 'yi':
      return AppLocalizationsYi();
    case 'yo':
      return AppLocalizationsYo();
    case 'yua':
      return AppLocalizationsYua();
    case 'yue':
      return AppLocalizationsYue();
    case 'zap':
      return AppLocalizationsZap();
    case 'zh':
      return AppLocalizationsZh();
    case 'zu':
      return AppLocalizationsZu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
