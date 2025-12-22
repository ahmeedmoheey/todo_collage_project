import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/my_them/my_theme.dart';
import '../core/utils/route_managers.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 870),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
          onGenerateRoute: RoutesManager.router,
          initialRoute: RoutesManager.home,
          theme: MyTheme.light,),
    );
  }
}