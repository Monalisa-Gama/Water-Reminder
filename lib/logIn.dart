import 'package:flutter/material.dart';
import 'package:prototipo/data.dart';
import 'package:prototipo/homePage.dart';
import 'package:prototipo/inicialScreen.dart';
import 'package:prototipo/singIn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

   late DatabaseProvider _databaseProvider;

  @override
  void initState() {
    super.initState();
    _initializeDatabaseProvider();
  }

  Future<void> _initializeDatabaseProvider() async {
    _databaseProvider = DatabaseProvider.db;
    await _databaseProvider.initDB(); // Inicialize o banco de dados aqui
  }

   void _login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // ignore: unnecessary_null_comparison
    if (_databaseProvider == null) {
      // Aguarda a inicialização do DatabaseProvider antes de fazer login
      await _initializeDatabaseProvider();
    }

    bool isAuthenticated = await _databaseProvider.userExists(_usernameController.text, _passwordController.text);

    if (isAuthenticated) {
      int? id = await _databaseProvider.buscarIdUsuario(_usernameController.text);
      await prefs.setInt('userId', id ?? 0);


      print('autenticado');
      _updateFirstRun();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DrinkWaterScreen()),
      );
    } else {
      print('não autenticado');
      // mandar para o cadastro
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => InitialInfoScreen()),
      );
    }
  }

  void _updateFirstRun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstRun', false);
  }


  void _toSingIn() async { 
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CadastroScreen()),
      );
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Log In',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Usuário:',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _usernameController,
              onChanged: (value) {
                setState(() {
                  // Não é necessário fazer nada aqui com os controladores
                  print("User: $value");
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Senha',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _passwordController,
              obscureText: true, // Para ocultar a senha
              onChanged: (value) {
                setState(() {
                  // Não é necessário fazer nada aqui com os controladores
                  print("Password: $value");
                });
              },
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: (_usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty)
                  ? _login
                  : null,
              child: Text('Salvar e Continuar'),
            ),
            SizedBox(height: 10),
            GestureDetector(
            child: Text('Cadastre-se', style: TextStyle(fontSize: 15.0), ), 
            onTap:(){ 
              _toSingIn();
            },
          )
          ],
        ),
      ),
    );
  }
}

