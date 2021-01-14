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
    final pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
    final regExp = RegExp(pattern);

    if (input.isEmpty) {
      return 'Enter an email';
    } else if (!regExp.hasMatch(input)) {
      return 'Enter a valid email';
    } else {
      return null;
    }
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
