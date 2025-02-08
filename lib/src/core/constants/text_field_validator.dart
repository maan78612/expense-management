class TextFieldValidator {
  // Validate password with enhanced error messages
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required. Please enter your password.";
    } else if (value.length <= 5) {
      return "Password must be at least 6 characters long. Please enter a longer password.";
    }
    return null;
  }
  static String? validatePhoneNumberUAE(String? value) {
    const String pattern = r'^\+971[0-9]{8,9}$';
    final RegExp regex = RegExp(pattern);

    if (value == null || value.isEmpty) {
      return "Phone number is required. Please enter your phone number.";
    } else if (!regex.hasMatch(value)) {
      return "Please enter a valid UAE phone number starting with +971 followed by 8 or 9 digits.";
    }
    return null;
  }

  // Validate confirm password with enhanced error messages
  static String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Confirm Password is required. Please re-enter your password to confirm.";
    } else if (value.length <= 5) {
      return "Confirm Password must be at least 6 characters long. Please enter a longer password.";
    }
    return null;
  }

  // Validate email with enhanced error messages
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required. Please enter your email address.";
    }

    if (!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@"
            r"[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\."
            r"[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
        .hasMatch(value)) {
      return "Invalid email format. Please enter a valid email address like example@domain.com.";
    }

    return null;
  }

  // Validate person name with enhanced error messages
  static String? validatePersonName(String? value) {
    if (value == null || value.isEmpty) {
      return "Name is required. Please enter your name.";
    }
    return null;
  }

  // Validate a generic field with enhanced error messages
  static String? validateField(String? value) {
    if (value == null || value.isEmpty) {
      return "This field is required. Please fill out this field.";
    }
    return null;
  }

  static String? validateMessage(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter message to proceed";
    }
    return null;
  }
}
