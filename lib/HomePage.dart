import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrinkWaterScreen extends StatefulWidget {
  @override
  _DrinkWaterScreenState createState() => _DrinkWaterScreenState();
}

class _DrinkWaterScreenState extends State<DrinkWaterScreen> {
  int _waterConsumed = 0; // Inicialmente, nenhum copo foi bebido
  double _dailyWaterGoal = 2000; // Meta diária de consumo de água em copos
  int _waterPerCup = 250; // Quantidade de água por copo


    @override
  void initState() {
    super.initState();
    _loadDailyWaterGoal();
  }

  Future<void> _loadDailyWaterGoal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double savedDailyWaterGoal = (prefs.getDouble('weight') ?? 0)*35;

    setState(() {
      _dailyWaterGoal = savedDailyWaterGoal;
    });
  }

  void _drinkWater() {
    setState(() {
      _waterConsumed += _waterPerCup; // Aumenta a quantidade de água consumida
    });
  }

  double _calculateWaterFraction() {
    return _waterConsumed / _dailyWaterGoal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Drink Water App',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Quantidade de Água bebida hoje:',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 30,),
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: _calculateWaterFraction(),
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    strokeWidth: 20,
                  ),
                ),
                MaterialButton(
                  onPressed: _drinkWater,
                  elevation: 4, // Define a elevação do botão
                  shape: CircleBorder(), // Define a forma como um círculo
                  color: const Color.fromARGB(255, 140, 199, 247), // Cor do botão
                  padding: EdgeInsets.all(16),
                  child: Icon(
                    Icons.local_drink, // Ícone de gota de água
                    size: 40, // Tamanho do ícone
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Consumido: $_waterConsumed ml',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 10),
            Text(
              'Meta diária: $_dailyWaterGoal ml',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Tamanho do copo: ',
                  style: TextStyle(fontSize: 16.0),
                ),
                DropdownButton<int>(
                  value: _waterPerCup,
                  onChanged: (newValue) {
                    setState(() {
                      _waterPerCup = newValue!;
                    });
                  },
                  items: <int>[50, 180, 250, 300, 400]
                      .map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value ml(s)'),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 10),
            /*ElevatedButton(
              onPressed: _drinkWater,
              child: Text('Beber $_waterPerCup copo(s)'),
            ),*/
          ],
        ),
      ),
    );
  }
}
