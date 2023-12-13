import 'package:flutter/material.dart';
import 'package:prototipo/data.dart';
import 'package:prototipo/inicialScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';


DatabaseProvider dbProvider = DatabaseProvider.db; // Obtém a instância do DatabaseProvider
class CadastroScreen extends StatelessWidget {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _cadastrar(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Aqui você tem os valores dos campos de texto, pode usá-los para o cadastro
    // Por exemplo, você pode chamar suas funções para inserir no banco de dados aqui

    // Exemplo:
    await dbProvider.inserirUsuario(username, password);
    int? id = await dbProvider.buscarIdUsuario(_usernameController.text);
    print(id);
    await prefs.setInt('userId', id ?? 0);
    _updateFirstRun();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => InitialInfoScreen()),
      );
  }

   void _updateFirstRun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstRun', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sing In',
          style: TextStyle(color: Colors.white),
        ),
      backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController, // Associando o controlador ao campo de texto
              decoration: InputDecoration(
                labelText: 'Usuário',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _passwordController, // Associando o controlador ao campo de texto
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _cadastrar(context); // Chama _cadastrar sem esperar um retorno
              },
              child: Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
