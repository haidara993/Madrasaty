enum UserType { Student, Teacher, Parent, Unkown }

class UserTypeHelper {
  static String getValue(UserType userType) {
    switch (userType) {
      case UserType.Parent:
        return "Parent";
      case UserType.Student:
        return "Student";
      case UserType.Teacher:
        return "Teacher";
      case UserType.Unkown:
        return "Unkown";
      default:
        return 'Unkown';
    }
  }

  static UserType getEnum(String userType) {
    if (userType == getValue(UserType.Parent)) {
      return UserType.Parent;
    } else if (userType == getValue(UserType.Student)) {
      return UserType.Student;
    } else if (userType == getValue(UserType.Teacher)) {
      return UserType.Teacher;
    } else {
      return UserType.Unkown;
    }
  }
}
