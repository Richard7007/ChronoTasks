import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_list/home_page.dart';
import 'package:to_do_list/utils/hive.dart';
import 'package:to_do_list/utils/splash_screen.dart';
import 'login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Box? box;

Future<void> _messageHandler(RemoteMessage message) async {
  //
  // ignore_for_file: avoid_print

  print('background message ${message.notification!.body}');
}

Future<void> main() async {
  await Hive.initFlutter();
  box = await Hive.openBox('user');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_messageHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan.shade400),
          useMaterial3: true,
          fontFamily: 'Orbitron',
          datePickerTheme:  DatePickerThemeData(
            backgroundColor: Colors.black,
            shadowColor: Colors.cyan.shade400,
            elevation: 2,
            surfaceTintColor: Colors.black12,
            dayForegroundColor: const WidgetStatePropertyAll(
              Colors.white,
            ),
            headerForegroundColor: Colors.white,
            weekdayStyle: const TextStyle(
              color: Colors.white,
            ),
            yearForegroundColor: const WidgetStatePropertyAll(Colors.white),
            yearOverlayColor: const WidgetStatePropertyAll(Colors.white),
          ),
          timePickerTheme: const TimePickerThemeData(
            backgroundColor: Colors.black,
            dialBackgroundColor: Colors.white,
            dayPeriodColor: Colors.white,
            hourMinuteColor: Colors.white,
            entryModeIconColor: Colors.white,
            helpTextStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen());
  }
}
