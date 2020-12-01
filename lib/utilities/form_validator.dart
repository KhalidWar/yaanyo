class FormValidator {
  String searchByEmail(String input) {
    if (input.isEmpty) {
      return 'Please provide a valid email';
    }
    return null;
  }

  String createNewGridBox(String input) {
    if (input.isEmpty) {
      return 'Name can not be empty';
    }
    return null;
  }

  String updateNameField(String input) {
    if (input.isEmpty) {
      return 'Please provide a valid name';
    }
    return null;
  }

  String authNameField(String input) {
    if (input.isEmpty) {
      return 'Enter your name';
    }
    return null;
  }

  String authEmailField(String input) {
    if (input.isEmpty) {
      return 'Provide a valid email';
    }
    return null;
  }

  String authPasswordField(String input) {
    if (input.isEmpty) {
      return 'Password must be 6 characters long';
    }
    return null;
  }

  String authPassword2Field(String input) {
    if (input.isEmpty) {
      return 'Password fields must match';
    }
    return null;
  }
}
