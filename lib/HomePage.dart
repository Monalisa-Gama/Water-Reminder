import 'package:flutter/material.dart';
import 'package:prototipo/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrinkWaterScreen extends StatefulWidget {
  @override
  _DrinkWaterScreenState createState() => _DrinkWaterScreenState();
}

class _DrinkWaterScreenState extends State<DrinkWaterScreen> {
  int _waterConsumed = 0; 
  double _dailyWaterGoal = 2000;
  int _waterPerCup = 250;

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
    _insereAgua(_waterPerCup);
    setState(() {
      _waterConsumed += _waterPerCup; 
    });
  }

  void _insereAgua( int volume) async{
    DatabaseProvider dbProvider = DatabaseProvider.db;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dbProvider.insertAgua(volume, prefs.getInt('userId') ?? 0, DateTime.now());
  }

  Future<int> _calculaTotal() async{
    DatabaseProvider dbProvider = DatabaseProvider.db;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return dbProvider.aguaDia(prefs.getInt('userId') ?? 0, DateTime.now());
  }

  Future<double> _calculateWaterFraction() async {
    int total = await _calculaTotal();
    print (total);
    return ( total / _dailyWaterGoal);
  
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
                FutureBuilder<double>(
                  future: _calculateWaterFraction(),
                  builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(
                        value: null,
                        backgroundColor: Colors.grey,
                        strokeWidth: 20,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Erro: ${snapshot.error}');
                    } else {
                      return SizedBox(
                        width: 200,
                        height: 200,
                        child: CircularProgressIndicator(
                          value: snapshot.data,
                          backgroundColor: Colors.grey,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          strokeWidth: 20,
                        ),
                      );
                    }
                  },
                ),
                MaterialButton(
                  onPressed: _drinkWater,
                  elevation: 4, 
                  shape: CircleBorder(), 
                  color: const Color.fromARGB(255, 140, 199, 247), 
                  padding: EdgeInsets.all(16),
                  child: Icon(
                    Icons.local_drink,
                    size: 40,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            FutureBuilder<int>(
              future: _calculaTotal(),
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text(
                    'Consumido: Carregando...',
                    style: TextStyle(fontSize: 20.0),
                  );
                } else if (snapshot.hasError) {
                  return Text(
                    'Erro ao carregar a quantidade consumida: ${snapshot.error}',
                    style: TextStyle(fontSize: 20.0),
                  );
                } else {
                  int quantidadeConsumida = snapshot.data ?? 0;
                  return Text(
                    'Consumido: $quantidadeConsumida ml',
                    style: TextStyle(fontSize: 20.0),
                  );
                }
              },
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
            
          ],
        ),
      ),
    );
  }
}
