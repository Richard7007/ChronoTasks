import 'package:flutter/material.dart';
import 'package:to_do_list/login_page.dart';

import '../home_page.dart';
import 'hive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AppHive().getIsLogged()
                ? const HomePage()
                : const LoginPage(
                    title: 'To Do List',
                  ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child:
             Text(
              'ChronoTasks',
              style: TextStyle(fontSize: 35, color: Colors.cyan),
            ),

      ),
    );
  }
}
