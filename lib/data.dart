import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseProvider {
  DatabaseProvider._(); // Construtor privado para evitar instâncias acidentais

  static final DatabaseProvider db = DatabaseProvider._();
  late Database _database;


  factory DatabaseProvider() {
    return db; // Retorna a instância estática
  }


  Future<Database> get database async {
    
    //if (_database != null) return _database;
    
    // Se o banco de dados ainda não foi inicializado, inicialize-o
    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    // Obtenha o diretório do dispositivo para armazenar o banco de dados
    var documentsDirectory = await getApplicationDocumentsDirectory();
    var path = join(documentsDirectory.path, "example.db");

    // Abra ou crie o banco de dados no local especificado
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    // Código para criar suas tabelas dentro do banco de dados
    await db.execute("CREATE TABLE IF NOT EXISTS user (id INTEGER PRIMARY KEY, username TEXT, key TEXT, peso REAL)");
    await db.execute("CREATE TABLE IF NOT EXISTS water (id INTEGER PRIMARY KEY, volume INTEGER, horario DATE, user_id INTEGER, FOREIGN KEY(user_id) REFERENCES user(id))");
    await db.execute("INSERT INTO user VALUES('1', 'mona','teste', 53.0)");
    // Adicione outras instruções CREATE TABLE conforme necessário para suas tabelas
  }

  // Exemplo de método para inserir dados em uma tabela
   Future<void> inserirUsuario(String username, String key) async {
    final db = await database;
    await db.insert('user', {'username': username, 'key': key});
  }

  Future<void> adicionarPeso(int userId, double? peso) async {
    final db = await database;
    
    await db.update(
      'user', // Nome da tabela
      {'peso': peso}, // Novos valores a serem atualizados
      where: 'id = ?', // Condição para atualização (neste caso, o ID do usuário)
      whereArgs: [userId], // Argumentos da condição
    );
  }

    Future<void> insertAgua(int ml, int userId, DateTime dia) async {
    final db = await database;
    String date = '${dia.year.toString().padLeft(4, '0')}-${dia.month.toString().padLeft(2, '0')}-${dia.day.toString().padLeft(2, '0')}';

    await db.insert('water', {'volume': ml, 'horario': date, 'user_id': userId});
  }

  // Exemplo de método para ler dados de uma tabela
  Future<List<Map<String, dynamic>>> getData() async {
    final db = await database;
    return await db.query('your_table');
  }

  Future<bool> userExists(String? username, String? key) async{
    final db = await database;
    List<Map<String, dynamic>>? users;

    users = await db.query(
    'user', 
    where: 'username = ? AND key = ?', 
    whereArgs: [username, key]);

    // ignore: unnecessary_null_comparison
    if(users != null){
    return true;
    }else{
      return false;
    }
  }

  Future<int?> buscarIdUsuario(String username) async {
    final db = await database;
    List<Map<String, dynamic>> usuarios = await db.query('user', where: 'username = ?', whereArgs: [username]);
    
    if (usuarios.isNotEmpty) {
      return usuarios.first['id'] as int;
    } else {
      return null; // Retorna null se o usuário não for encontrado
    }
  }

  Future<int> aguaDia(int user, DateTime dia) async {
    final db = await database;
  String date = '${dia.year.toString().padLeft(4, '0')}-${dia.month.toString().padLeft(2, '0')}-${dia.day.toString().padLeft(2, '0')}';

  final result = await db.rawQuery(
    'SELECT IFNULL(SUM(volume), 0) as total FROM water WHERE user_id = ? AND DATE(horario) = ?',
    [user, date],
  );

  // Verifica se há resultados e se a chave 'total' está presente
  if (result.isNotEmpty && result.first.containsKey('total')) {
    var total = result.first['total'];
    if (total is int) {
      return total;
    } else if (total is num) {
      return total.toInt();
    } else {
      // Trata qualquer outro tipo de valor retornado
      print('Valor retornado não é um número inteiro');
      return 0; // Ou outro valor padrão adequado para o seu aplicativo
    }
  } return 0;
  
  }

  
}
