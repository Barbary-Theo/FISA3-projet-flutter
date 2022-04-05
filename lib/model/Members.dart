class Members{


  String _email = "";
  String _id = "";


  Members(this._email, this._id);

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }
}