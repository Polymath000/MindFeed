
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get ok => 'De acuerdo';

  @override
  String get yes => 'Sí';

  @override
  String get cancel => 'Cancelar';

  @override
  String get appTitle => 'Editor de markdown';

  @override
  String get previewToolTip => 'Avance';

  @override
  String get switchThemeMenuItem => 'Tema de cambio';

  @override
  String get switchViewMenuItem => 'Vista de interruptor';

  @override
  String get openFileMenuItem => 'Abierto';

  @override
  String get markdownTextInputLabel => 'Ingrese su texto de Markdown aquí';

  @override
  String get error => 'Error';

  @override
  String get unableToOpenFileError =>
      'No se puede abrir el archivo, intente abrirlo desde la opción de archivo abierto en el menú';

  @override
  String get unableToOpenFileFromMenuError => 'No se puede abrir el archivo';

  @override
  String get emptyInputTextContent => 'Por favor ingrese algún texto';

  @override
  String get clear => 'Claro';

  @override
  String get clearAllTitle => 'Despejar todo';

  @override
  String get clearAllContent =>
      '¿Estás seguro de que quieres borrar todo el texto?';

  @override
  String get saveFileDialogTitle => 'Ingrese el nombre del archivo';

  @override
  String get save => 'Ahorrar';

  @override
  String get linkDialogTextTitle => 'Texto';

  @override
  String get linkDialogLinkTitle => 'Enlace';

  @override
  String get enterLinkTextDialogTitle => 'Ingrese el enlace';

  @override
  String get bold => 'Atrevido';

  @override
  String get italic => 'Itálico';

  @override
  String get link => 'Enlace';

  @override
  String get image => 'Imagen';

  @override
  String get heading => 'Título';

  @override
  String get code => 'Código';

  @override
  String get bulletList => 'Lista de balas';

  @override
  String get quote => 'Cita';

  @override
  String get horizontalRule => 'Regla horizontal';

  @override
  String get strikethrough => 'Fusible';
}
