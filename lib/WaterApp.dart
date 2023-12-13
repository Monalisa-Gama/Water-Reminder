
import 'package:flutter/material.dart';
import 'package:prototipo/HomePage.dart';
import 'package:prototipo/InicialScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drink Water App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CheckFirstTimeScreen(),
    );
  }
}

class CheckFirstTimeScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkFirstTime(),
      
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          bool isFirstTime = snapshot.data!;
          if (isFirstTime) {
            _updateFirstRun();
            return InitialInfoScreen(); // Redireciona para a tela inicial
          } else {
            return DrinkWaterScreen(); // Redireciona para a tela principal
          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Future<bool> _checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstRun') ?? true;

    return isFirstTime;
  }

  _updateFirstRun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstRun', false);
  }
}