import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_sqlite/models/todo_model.dart';

class DbAppConnection {
  
  /// Singleton (private constructor )
  DbAppConnection._();

  /// accessing the connection class object and create db class object
  static final DbAppConnection db = DbAppConnection._();
  
  
  
  /// creating global static values
  static const String TABLE_NAME = 'todo';
  static const String TABLE_COLUMN_TITLE = 'todo_title';
  static const String TABLE_COLUMN_DESC = 'todo_desc';
  static const String TABLE_COLUMN_ID = 'id';

  /// all db logic

  Database? myDb;

  Future<Database> getDB() async {
    if (myDb != null) {
      return myDb!;
    } else {
     myDb = await initDb();
     return myDb!;
    }
  }

  
  Future<Database> initDb() async {
    var rootPath = await getApplicationDocumentsDirectory();
    var actualPath = join(rootPath.path, 'todo_db.db');

    /// db create
    return await openDatabase( actualPath, version: 1, onCreate: (db, version) async {

      /// create table
      await db.execute(
          'CREATE TABLE $TABLE_NAME ($TABLE_COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT, $TABLE_COLUMN_TITLE TEXT, $TABLE_COLUMN_DESC TEXT )');
        
      },
    );
  }
  

  /// insert data
  void addTodo({required TodoModel todoModel}) async{
    var db = await getDB();
    
    db.insert(TABLE_NAME, todoModel.toMap());
    
  }

  /// fetch data
  Future<List<TodoModel>> fetchAllTodo()async{
    
    var db = await getDB();
    var data = await db.query(TABLE_NAME);
    
    List<TodoModel> dataList = [];
    
    for(Map<String,dynamic> dataMap in data){
      
      var dataModel = TodoModel.fromMap(dataMap);
      dataList.add(dataModel);
      
    }
    return dataList;
  }
  
  
  updateTodo(TodoModel todoModel) async{

    var db = await getDB();
    db.update(TABLE_NAME, todoModel.toMap(), where: "$TABLE_COLUMN_ID = ?", whereArgs: ['${todoModel.id}']);
    // db.update(TABLE_NAME, todoModel.toMap(), where: "$TABLE_COLUMN_ID = ${todoModel.id}");
    
  }
  
  
  deleteTodo(int id) async{
    var db = await getDB();
    db.delete(TABLE_NAME, where: "$TABLE_COLUMN_ID = ?", whereArgs: ['$id']);
    
  }
}
