import 'package:projetmobiles6/model/Members.dart';

class Task{

  String _id = "";
  String _name = "";
  String _mainElementId = "";
  int _status = 0;
  double _x = 10;
  double _y = 10;
  bool _validate = false;
  DateTime _deadLine = DateTime.now();
  String _desc = "";

  String get desc => _desc;

  set desc(String value) {
    _desc = value;
  }

  Task(this._name, this._status, this._x, this._y, this._mainElementId, this._validate);

  Task.withDate(String name, int status, double x, double y, String mainElementId, bool validate, DateTime deadLine, String id,String desc){
    _name = name;
    _status = status;
    _x = x;
    _y = y;
    _mainElementId = mainElementId;
    _validate = validate;
    _deadLine = deadLine;
    _id = id;
    _desc = desc;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  int get status => _status;

  set status(int value) {
    _status = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  double get x => _x;

  set x(double value) {
    _x = value;
  }

  double get y => _y;

  set y(double value) {
    _y = value;
  }

  String get mainElementId => _mainElementId;

  set mainElementId(String value) {
    _mainElementId = value;
  }

  bool get validate => _validate;

  set validate(bool value) {
    _validate = value;
  }

  DateTime get deadLine => _deadLine;

  set deadLine(DateTime value) {
    _deadLine = value;
  }
}