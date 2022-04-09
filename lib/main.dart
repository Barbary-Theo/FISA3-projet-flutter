import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';

int selectedIndex = 0;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAaTcKPegjcZjTZZtlAuewGN40nXBJF-jA",
        appId: "1:117826766373:ios:a0c20e7c6aa99ad3cd61cc",
        messagingSenderId: "XXX",
        projectId: "projetmobiles6",
      ),
      name: "projetmobiles6"
      );

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashPage(),
    );
  }
}
