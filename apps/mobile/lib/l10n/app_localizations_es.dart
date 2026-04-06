// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'WouPass';

  @override
  String get createMasterPassword => 'Crear Contraseña Maestra';

  @override
  String get masterPassword => 'Contraseña Maestra';

  @override
  String get confirmPassword => 'Confirmar Contraseña Maestra';

  @override
  String get createVault => 'Crear Bóveda';

  @override
  String get unlock => 'Desbloquear';

  @override
  String get welcomeBack => 'Bienvenido';

  @override
  String get enterMasterPassword =>
      'Ingresa tu contraseña maestra para desbloquear';

  @override
  String get vaultUnlocked => 'Bóveda Desbloqueada';

  @override
  String get passwords => 'Contraseñas';

  @override
  String get categories => 'Categorías';

  @override
  String get settings => 'Configuración';

  @override
  String get searchPasswords => 'Buscar contraseñas...';

  @override
  String get noPasswordsYet => 'Aún no hay contraseñas';

  @override
  String get addPassword => 'Agregar Contraseña';

  @override
  String get editPassword => 'Editar Contraseña';

  @override
  String get title => 'Título';

  @override
  String get username => 'Usuario / Email';

  @override
  String get password => 'Contraseña';

  @override
  String get website => 'Sitio Web / URL';

  @override
  String get notes => 'Notas';

  @override
  String get save => 'Guardar';

  @override
  String get update => 'Actualizar';

  @override
  String get delete => 'Eliminar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get copied => 'Copiado (se borra en 30s)';

  @override
  String get exportVault => 'Exportar Bóveda';

  @override
  String get importVault => 'Importar Bóveda';

  @override
  String get lock => 'Bloquear';

  @override
  String get twoFA => '2FA';
}
