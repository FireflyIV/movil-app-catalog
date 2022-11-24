
import '../../../constants/text_strings.dart';

class SignUpWithEmailAndPasswordFailure {
  final String message;

  const SignUpWithEmailAndPasswordFailure([this.message = tAuthExceptionDefault]);

  factory SignUpWithEmailAndPasswordFailure.code(String code){
    switch(code) {
      case 'weak-password':
        return const SignUpWithEmailAndPasswordFailure(tAuthExceptionWeakPassword);
      case 'invalid-email':
        return const SignUpWithEmailAndPasswordFailure(tAuthExceptionInvalidEmail);
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordFailure(tAuthExceptionEmailUsed);
      case 'operation-not-allowed':
        return const SignUpWithEmailAndPasswordFailure(tAuthExceptionOperationNotAllowed);
      case 'user-disabled':
        return const SignUpWithEmailAndPasswordFailure(tAuthExceptionUserDisabled);
        default:
          return const SignUpWithEmailAndPasswordFailure();
    }
  }
}