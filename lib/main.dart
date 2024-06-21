import 'register/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  initializeDateFormatting(
      'vi', null); // Initialize date formatting for Vietnamese
  runApp(CupertinoApp(
    localizationsDelegates: [
      GlobalCupertinoLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: <Locale>[
      Locale('vi', 'VN'), // American English

      // ...
    ],
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StartAppWidget(),
    );
  }
}
