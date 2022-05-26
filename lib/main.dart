import 'package:chatify_app/pages/home_page.dart';
import 'package:chatify_app/pages/login_page.dart';
import 'package:chatify_app/pages/register_page.dart';
import 'package:chatify_app/pages/splash_page.dart';
import 'package:chatify_app/providers/authentication_provider.dart';
import 'package:chatify_app/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import 'package:firebase_analytics/firebase_analytics.dart';

void main() {
  runApp(
    SplashPage(
      key: UniqueKey(),
      onInitializationComplete: () {
        runApp(MainApp());
      },
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (BuildContext _context) {
            return AuthenticationProvider();
          },
        )
      ],
      child: MaterialApp(
        title: 'Chatify',
        theme: ThemeData(
          backgroundColor: const Color.fromRGBO(36, 35, 49, 1.0),
          scaffoldBackgroundColor: const Color.fromRGBO(36, 35, 49, 1.0),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color.fromRGBO(30, 29, 37, 1.0),
          ),
        ),
        navigatorKey: NavigationService.navigatorKey,
        initialRoute: '/login',
        routes: {
          '/login': (BuildContext context) => LoginPage(),
          '/register': (BuildContext context) => RegisterPage(),
          '/home': (BuildContext context) => HomePage(),
        },
      ),
    );
  }
}
