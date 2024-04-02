import 'package:todo_sqlite/db_connections/connection.dart';

class TodoModel {
  int id;
  String title;
  String desc;

  TodoModel({this.id = 0, required this.title, required this.desc});

  /// map to model (create function - fromMap)
  /// ( if you make a function which is return class-function then you should use factory )

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
        id: map[DbAppConnection.TABLE_COLUMN_ID],
        title: map[DbAppConnection.TABLE_COLUMN_TITLE],
        desc: map[DbAppConnection.TABLE_COLUMN_DESC]);
  }

  
  
  /// model to map (create function - toMap)

  Map<String, dynamic> toMap() {
    return {
      DbAppConnection.TABLE_COLUMN_TITLE: title,
      DbAppConnection.TABLE_COLUMN_DESC: desc
    };
  }
}
