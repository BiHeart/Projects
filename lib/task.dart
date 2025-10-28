import 'package:flutter/material.dart';

class Task{
  final String? _taskId;  //underscore-al lehet private az adattag
  String _userId;
  String _title;
  String? _description;
  String _status;

  //konstruktorban a [] között lévő adattagok opciónálisak lesznek

  Task(
   this._userId, this._title, [this._taskId, this._description, this._status = 'Incomplete']
  );


  String get status => _status;
  set status(String value){
    _status = value;
  }

  String get description => _description??'';
  set description(String value){
    _description = value;
  }

  String get title => _title;
  set title(String value){
    _title = value;
  }

  String get userId => _userId;
  set userId(String value){
    _userId = value;
  }

  String? get taskId => _taskId;
  /*set taskId(String value){
    taskId = value;
  }*/

  static getDummyTaskList(){
    return List.generate(20, (index) => Task('1', 'Sample task $index',index.toString(),'Sample description $index'));
  }

}