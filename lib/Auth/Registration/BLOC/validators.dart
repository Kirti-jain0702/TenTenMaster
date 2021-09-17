class Validators {
  static final RegExp _emailPattern = RegExp(
      '^[a-zA-Z0-9.!#\$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*\$');

  static isNameValid(String name) {
    return name.length > 0;
  }

  static isEmailValid(String email) {
    return _emailPattern.hasMatch(email);
  }
}
