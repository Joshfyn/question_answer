import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:question_answer/models/uploadPicture.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String uploadTable = 'upload_table';
  String colId = 'id';
  String colFirstPicture = 'first_picture';
  String colSecondPicture = 'second_picture';
  String colThirdPicture = 'third_picture';
  String colTitle = 'title';
  String colDescription = 'description';
  String colTimestamp = 'timestamp';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'uploadPics.db';

    // Open/create the database at a given path
    var uploadPicsDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return uploadPicsDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $uploadTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colFirstPicture TEXT, '
        '$colSecondPicture TEXT, $colThirdPicture TEXT, $colTitle TEXT, $colDescription TEXT, $colTimestamp TEXT)');
  }

  //Retrieve all the pictures and description from the Database
  Future<List<Map<String, dynamic>>> getPicturesList() async {
    Database db = await this.database;

    var result = await db.query(uploadTable, orderBy: '$colId DESC');
    return result;
  }

  //Retrieve only last row
  Future<List<Map<String, dynamic>>> getPicture() async {
    Database db = await this.database;

    var result = await db.rawQuery('SELECT * FROM $uploadTable ORDER BY $colId DESC LIMIT 1');
    return result;
  }

  //Upload the pictures and description into the Database
  Future<int> uploadPictures(UploadPicture uploadPicture) async {
    Database db = await this.database;

    var result = await db.insert(uploadTable, uploadPicture.toMap());
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updatePictures(UploadPicture uploadPicture) async {
    var db = await this.database;
    var result = await db.update(uploadTable, uploadPicture.toMap(),
        where: '$colId = ?', whereArgs: [uploadPicture.id]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteQuestion(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $uploadTable WHERE $colId = $id');
    return result;
  }

  // Get number of Note objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $uploadTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  //Get List of Map from the database anc converts it to List of Questions
  Future<List<UploadPicture>> getAllQuestionsList() async {
    Database db = await this.database;

    var questionMapList = await getPicturesList();
    int count = questionMapList.length;

    List<UploadPicture> uploadList = List<UploadPicture>();
    for (int i = 0; i < count; i++) {
      uploadList.add(UploadPicture.fromMap(questionMapList[i]));
    }
    return uploadList;
  }


  //Get List of Map from the database anc converts it to a List of one Question
  Future<List<UploadPicture>>  getPictureList() async {
    Database db = await this.database;
    var questionMapList = await getPicture();
    int count = questionMapList.length;

    List<UploadPicture> oneList = List<UploadPicture>();
    for (int i = 0; i < count; i++) {
      oneList.add(UploadPicture.fromMap(questionMapList[i]));
    }
    return oneList;
  }

}
