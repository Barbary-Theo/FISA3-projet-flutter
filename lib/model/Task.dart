class Task{

  String _name = "";
  String _description = "";
  DateTime _deadLine = DateTime.now();
  List<String> _members = <String>[];
  int _status = 0;

  Task(this._name, this._description, this._deadLine, this._members,
      this._status);

  int get status => _status;

  set status(int value) {
    _status = value;
  }

  List<String> get members => _members;

  set members(List<String> value) {
    _members = value;
  }

  DateTime get deadLine => _deadLine;

  set deadLine(DateTime value) {
    _deadLine = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }
}