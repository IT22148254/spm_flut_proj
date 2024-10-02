// lib/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'question.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the database
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Get the default database location
    String path = join(await getDatabasesPath(), 'quiz_world.db');

    // Open the database, creating it if it doesn't exist
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create the questions table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT NOT NULL,
        answer1 TEXT NOT NULL,
        answer2 TEXT NOT NULL,
        correctAnswer TEXT NOT NULL
      )
    ''');
  }

  // Insert a question into the database
  Future<int> insertQuestion(Question question) async {
    Database db = await database;
    return await db.insert(
      'questions',
      question.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve all questions from the database
  Future<List<Question>> getQuestions() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('questions');

    return List.generate(maps.length, (i) {
      return Question.fromMap(maps[i]);
    });
  }

  // Update a question
  Future<int> updateQuestion(Question question) async {
    Database db = await database;
    return await db.update(
      'questions',
      question.toMap(),
      where: 'id = ?',
      whereArgs: [question.id],
    );
  }

  // Delete a question
  Future<int> deleteQuestion(int id) async {
    Database db = await database;
    return await db.delete(
      'questions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
