import '../../../constants/text_strings.dart';

class LoginWithEmailAndPasswordFailure {
  final String message;

  const LoginWithEmailAndPasswordFailure([this.message = tAuthExceptionLoginDefault]);

  factory LoginWithEmailAndPasswordFailure.code(String code){
    switch(code) {
      case 'wrong-password':
        return const LoginWithEmailAndPasswordFailure(tAuthExceptionWrongPassword);
      case 'invalid-email':
        return const LoginWithEmailAndPasswordFailure(tAuthExceptionInvalidEmail);
      case 'user-not-found':
        return const LoginWithEmailAndPasswordFailure(tAuthExceptionUserNotFound);
      case 'user-disabled':
        return const LoginWithEmailAndPasswordFailure(tAuthExceptionUserDisabled);
      default:
        return const LoginWithEmailAndPasswordFailure();
    }
  }
}