import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../config/my_them/my_theme.dart';
import '../core/utils/route_managers.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../l10n/app_localizations.dart';
import '../provider/provider.dart';
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SettingsProvider>(context);
    return ScreenUtilInit(
      designSize: const Size(412, 870),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
          title: 'Localizations Sample App',
          localizationsDelegates: [
           AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en'), // English
            Locale('ar'), // Arabic
          ],
        locale:Locale(provider.currentLanguage),
        debugShowCheckedModeBanner: false,
          onGenerateRoute: RoutesManager.router,
          initialRoute: RoutesManager.login,
          theme: MyTheme.light,
          darkTheme: MyTheme.dark,
          themeMode: provider.currentTheme),
    );
  }
}