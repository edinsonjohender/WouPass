import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'WouPass'**
  String get appName;

  /// No description provided for @createMasterPassword.
  ///
  /// In en, this message translates to:
  /// **'Create Master Password'**
  String get createMasterPassword;

  /// No description provided for @masterPassword.
  ///
  /// In en, this message translates to:
  /// **'Master Password'**
  String get masterPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Master Password'**
  String get confirmPassword;

  /// No description provided for @createVault.
  ///
  /// In en, this message translates to:
  /// **'Create Vault'**
  String get createVault;

  /// No description provided for @unlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @enterMasterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your master password to unlock'**
  String get enterMasterPassword;

  /// No description provided for @vaultUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Vault Unlocked'**
  String get vaultUnlocked;

  /// No description provided for @passwords.
  ///
  /// In en, this message translates to:
  /// **'Passwords'**
  String get passwords;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @searchPasswords.
  ///
  /// In en, this message translates to:
  /// **'Search passwords...'**
  String get searchPasswords;

  /// No description provided for @noPasswordsYet.
  ///
  /// In en, this message translates to:
  /// **'No passwords yet'**
  String get noPasswordsYet;

  /// No description provided for @addPassword.
  ///
  /// In en, this message translates to:
  /// **'Add Password'**
  String get addPassword;

  /// No description provided for @editPassword.
  ///
  /// In en, this message translates to:
  /// **'Edit Password'**
  String get editPassword;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username / Email'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website / URL'**
  String get website;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied (clears in 30s)'**
  String get copied;

  /// No description provided for @exportVault.
  ///
  /// In en, this message translates to:
  /// **'Export Vault'**
  String get exportVault;

  /// No description provided for @importVault.
  ///
  /// In en, this message translates to:
  /// **'Import Vault'**
  String get importVault;

  /// No description provided for @lock.
  ///
  /// In en, this message translates to:
  /// **'Lock'**
  String get lock;

  /// No description provided for @twoFA.
  ///
  /// In en, this message translates to:
  /// **'2FA'**
  String get twoFA;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
