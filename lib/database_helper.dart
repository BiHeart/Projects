import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'task.dart';

class DatabaseHelper {


  late Database _database;

  _open() async{
    _database = await openDatabase(
      join(await getDatabasesPath(), 'todo_database'),
      onCreate: (db,version){
        return db.execute('CREATE TABLE tasks(id INTEGER PRIMARY KEY, user_id TEXT, title TEXT, desc TEXT, status TEXT)');
      },
      version: 1,
    );
  }  

  Future<int> addtask(Map<String,String> taskInfo) async{
    await _open();
    return _database.insert('tasks', taskInfo);
  }

  Future<List<Task>> getTasks() async{
    await _open();
    List<Map> taskMap = await _database.query('tasks', orderBy: 'id desc');

    List<Task> listTasks = List.generate(
      taskMap.length, 
      (index) => Task(
        taskMap[index]['user_id'],
        taskMap[index]['title'],
        taskMap[index]['id'].toString(),
        taskMap[index]['desc'],
        taskMap[index]['status']));

   return listTasks;     
  }

  Future<Task> getOneTask(String taskId) async{
    await _open();
    List<Map> taskMaps = 
      await _database.query('tasks', where: 'id=?', whereArgs: [taskId]);
    Map taskInfoMap = taskMaps.first;

    return Task(taskInfoMap['user_id'], taskInfoMap['title'], taskInfoMap['id'].toString(), taskInfoMap['desc'], taskInfoMap['status']);
  }

  Future<bool> deleteTask(String taskId) async{
    await _open();
    int rowsDeleted = await _database.delete('tasks', where: 'id=?', whereArgs: [taskId]);

    return rowsDeleted==1;
  }

  Future<bool> updateTask(String taskId, Map<String,String> taskInfo) async{
    await _open();
    int rowsUpdated = await _database.update('tasks', taskInfo, where: 'id=?', whereArgs: [taskId]);

    return rowsUpdated == 1;
  }

}