
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get ok => 'D\'accord';

  @override
  String get yes => 'Oui';

  @override
  String get cancel => 'Annuler';

  @override
  String get appTitle => 'Éditeur de Markdown';

  @override
  String get previewToolTip => 'Prévisualisation';

  @override
  String get switchThemeMenuItem => 'THÈME DE STIT';

  @override
  String get switchViewMenuItem => 'Vue de commutation';

  @override
  String get openFileMenuItem => 'Ouvrir';

  @override
  String get markdownTextInputLabel => 'Entrez votre texte Markdown ici';

  @override
  String get error => 'Erreur';

  @override
  String get unableToOpenFileError =>
      'Impossible d\'ouvrir le fichier, essayez de l\'ouvrir à partir de l\'option Open Fichier dans le menu';

  @override
  String get unableToOpenFileFromMenuError => 'Impossible d\'ouvrir le fichier';

  @override
  String get emptyInputTextContent => 'Veuillez saisir du texte';

  @override
  String get clear => 'Clair';

  @override
  String get clearAllTitle => 'Effacer tout';

  @override
  String get clearAllContent =>
      'Êtes-vous sûr que vous souhaitez effacer tout le texte?';

  @override
  String get saveFileDialogTitle => 'Entrez le nom du fichier';

  @override
  String get save => 'Sauvegarder';

  @override
  String get linkDialogTextTitle => 'Texte';

  @override
  String get linkDialogLinkTitle => 'Lien';

  @override
  String get enterLinkTextDialogTitle => 'Entrez le lien';

  @override
  String get bold => 'Audacieux';

  @override
  String get italic => 'Italique';

  @override
  String get link => 'Lien';

  @override
  String get image => 'Image';

  @override
  String get heading => 'Titre';

  @override
  String get code => 'Code';

  @override
  String get bulletList => 'Liste de balles';

  @override
  String get quote => 'Citation';

  @override
  String get horizontalRule => 'Règle horizontale';

  @override
  String get strikethrough => 'Strikethrough';
}
