class Regex {
  bool isValidEmail(String email) {
    return RegExp(r"^([a-zA-Z0-9!#$%&*+=?^_`{|}~-]+(\.[ A-Za-z0-9!#$%&*+=?^_`{|}~-]+)*)@(([ a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9] )?\.)+[a-zA-Z0-9]([a-zA-Z0-9-]*[a-z A-Z0-9])?)$")
        .hasMatch(email);
  }

  bool isNumeric(String value) {
    final RegExp regex = RegExp(r'^[0-9]+$');
    return regex.hasMatch(value);
  }
}