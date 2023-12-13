import 'package:flutter/material.dart';
import 'package:prototipo/data.dart';
import 'package:prototipo/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';


class InitialInfoScreen extends StatefulWidget {
  @override
  _InitialInfoScreenState createState() => _InitialInfoScreenState();
}

class _InitialInfoScreenState extends State<InitialInfoScreen> {
  String? _selectedGender;
  double? _height;
  double? _weight;

  void _saveUserInfoAndNavigate() async {
    DatabaseProvider dbProvider = DatabaseProvider.db;

 
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    await prefs.setString('gender', _selectedGender ?? '');
    await prefs.setDouble('height', _height ?? 0);
    await prefs.setDouble('weight', _weight ?? 0);
    await dbProvider.adicionarPeso(prefs.getInt('userId') ?? 0, _weight);
    

    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DrinkWaterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informações Iniciais',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Selecione seu gênero:',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedGender,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGender = newValue;
                });
              },
              items: <String>['Masculino', 'Feminino', 'Outro']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              'Informe sua altura (cm):',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _height = double.tryParse(value);
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Informe seu peso (kg):',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _weight = double.tryParse(value);
                });
              },
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: (_selectedGender != null && _height != null && _weight != null)
                  ? _saveUserInfoAndNavigate
                  : null,
              child: Text('Salvar e Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}