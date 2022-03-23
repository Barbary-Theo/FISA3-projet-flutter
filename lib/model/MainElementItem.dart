abstract class MainElementItem{

  String _name = "";
  String _description = "";

  MainElementItem(String name, String description){
    _name = name;
    _description = description;
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