import 'package:projetmobiles6/model/Task.dart';

class Categorie {
  List<Task> _tasks = <Task>[];
  String _name = "";
  String id = "";

  Categorie(this._tasks, this._name, this.id);

  Categorie.name(this._name);

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  List<Task> get tasks => _tasks;

  set tasks(List<Task> value) {
    _tasks = value;
  }
}
