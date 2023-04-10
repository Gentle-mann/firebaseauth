import 'package:flutter/material.dart';
import 'package:login_page/pages/email_verification.dart';
import 'package:login_page/pages/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:login_page/data/user_dao.dart';

import 'pages/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserDao>(
          lazy: false,
          create: (_) => UserDao(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.openSansTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: Consumer<UserDao>(
          builder: ((context, userDao, child) {
            if (userDao.isLoggedIn() && userDao.isEmailVerified()) {
              return const HomePage();
            } else if (userDao.isLoggedIn() && !userDao.isEmailVerified()) {
              return EmailVerificationScreen(
                  email: userDao.getEmail(), isNewUser: true);
            } else {
              return const LoginPage();
            }
          }),
        ),
      ),
    );
  }
}
