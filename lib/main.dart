import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movie/Model/Film/film.dart';
import 'package:movie/Screen/Account.dart';
import 'package:movie/Screen/ForgotPassword.dart';
import 'package:movie/Screen/ListMovieFavourite.dart';
import 'package:movie/Screen/Login.dart';
import 'package:movie/Screen/MovieDetailScreen.dart';
import 'package:movie/Screen/Search.dart';
import 'package:movie/Screen/SignUp.dart';
import 'package:movie/Screen/Trangchu.dart';
import 'package:movie/Screen/video.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movie/firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie trailer',
      // home: Login(),
      initialRoute: '/',
      routes: {
        '/': (context) => Login(),
        '/video': (context) {
          final String key =
              ModalRoute.of(context)!.settings.arguments as String;
          return Video(
            url: key,
          );
        },
        '/movieDetail': (context) {
          final Movie movie =
              ModalRoute.of(context)!.settings.arguments as Movie;
          return MovieDetailScreen(movie: movie);
        },
        '/homepage': (context) => HomePage(),
        '/signup': (context) => const SignUp(),
        '/search': ((context) => SearchMovie()),
        '/moviefavourite': (context) => MovieFavourite(),
        '/account': (context) => Account(),
        '/forgotPassword': (context) => ForggotPassword()
      },

      debugShowCheckedModeBanner: false,
    );
  }
}
