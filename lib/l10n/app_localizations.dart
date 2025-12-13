import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @addNewTask.
  ///
  /// In en, this message translates to:
  /// **'Add new task'**
  String get addNewTask;

  /// No description provided for @weakPasswordMessage.
  ///
  /// In en, this message translates to:
  /// **'The password provided is too weak.'**
  String get weakPasswordMessage;

  /// No description provided for @wrongEmailOrPasswordMessage.
  ///
  /// In en, this message translates to:
  /// **'Wrong email or password'**
  String get wrongEmailOrPasswordMessage;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'enter your full name'**
  String get fullName;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'enter your user name'**
  String get userName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'enter your email address'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'enter your password'**
  String get password;

  /// No description provided for @passwordConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get passwordConfirmation;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'weak-password'**
  String get weakPassword;

  /// No description provided for @emailInUse.
  ///
  /// In en, this message translates to:
  /// **'email-already-in-use'**
  String get emailInUse;

  /// No description provided for @invalidCredential.
  ///
  /// In en, this message translates to:
  /// **'invalid-credential'**
  String get invalidCredential;

  /// No description provided for @emailInUseMessage.
  ///
  /// In en, this message translates to:
  /// **'The account already exists for that email.'**
  String get emailInUseMessage;

  /// No description provided for @todoList.
  ///
  /// In en, this message translates to:
  /// **'ToDoList'**
  String get todoList;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkMode;

  /// No description provided for @englishApp.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishApp;

  /// No description provided for @arabicApp.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabicApp;

  /// No description provided for @enterTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Plz, enter task title'**
  String get enterTaskTitle;

  /// No description provided for @enterDescriptionTask.
  ///
  /// In en, this message translates to:
  /// **'enter your task title'**
  String get enterDescriptionTask;

  /// No description provided for @plzEnterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Plz enter email'**
  String get plzEnterYourEmail;

  /// No description provided for @notHaveAcc.
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account? Create Account'**
  String get notHaveAcc;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign-In'**
  String get signIn;

  /// No description provided for @userLoggedInSuccess.
  ///
  /// In en, this message translates to:
  /// **'User Logged in successfully'**
  String get userLoggedInSuccess;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @anErrorPlzTryAgain.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again'**
  String get anErrorPlzTryAgain;

  /// No description provided for @waiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting...!'**
  String get waiting;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign-Up'**
  String get signUp;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'alreadyHaveAnAccount'**
  String get alreadyHaveAnAccount;

  /// No description provided for @emailBadFormat.
  ///
  /// In en, this message translates to:
  /// **'Email bad format'**
  String get emailBadFormat;

  /// No description provided for @passNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Password doesn\'t match'**
  String get passNotMatch;

  /// No description provided for @plzEnterTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Plz, enter task title'**
  String get plzEnterTaskTitle;

  /// No description provided for @plzEnterYourDescription.
  ///
  /// In en, this message translates to:
  /// **'Plz, enter description'**
  String get plzEnterYourDescription;

  /// No description provided for @sorryDescription.
  ///
  /// In en, this message translates to:
  /// **'Sorry, description should be at least 6 chars'**
  String get sorryDescription;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @addTask.
  ///
  /// In en, this message translates to:
  /// **'Add task'**
  String get addTask;

  /// No description provided for @enterTimeOut.
  ///
  /// In en, this message translates to:
  /// **'enter timeout'**
  String get enterTimeOut;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
