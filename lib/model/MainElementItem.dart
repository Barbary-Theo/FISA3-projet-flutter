abstract class MainElementItem {
  String _name = "";
  String _description = "";
  String _id = "";

  MainElementItem(this._name, this._description, this._id);

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}
