import 'package:flutter/material.dart';
import 'loginPage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key key}) : super(key: key);

  @override
  State<SplashPage> createState() => _Splash();
}

class _Splash extends State<SplashPage> {
  _Splash() {
    pageSwapping();
  }

  void pageSwapping() async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Done&Gone",
              style: Theme.of(context).textTheme.headline5,
            ),
            Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 15),
              child: Image.asset('assets/logo.png',
                  width: MediaQuery.of(context).size.width / 3.5),
            ),
          ],
        ),
      ),
    );
  }
}
