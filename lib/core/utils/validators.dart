class Validators {
  static final RegExp _usernameRegex = RegExp(
    r'^[a-zA-Z0-9_]{3,20}$',
  );

  static final RegExp _passwordRegex = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Пожалуйста, введите логин';
    }
    if (!_usernameRegex.hasMatch(value)) {
      return 'Логин должен содержать от 3 до 20 символов и может включать буквы, цифры и знак подчеркивания';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Пожалуйста, введите пароль';
    }
    if (!_passwordRegex.hasMatch(value)) {
      return 'Пароль должен содержать минимум 8 символов, включая буквы и цифры';
    }
    return null;
  }
} 