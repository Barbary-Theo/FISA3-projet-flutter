import 'package:projetmobiles6/model/MainElementItem.dart';
import 'package:projetmobiles6/model/Task.dart';

class ToDo extends MainElementItem{

  List<Task> _taskList = <Task>[];

  ToDo(String name, String description) : super(name, description);

  addTask(Task task){
    _taskList.add(task);
  }



}