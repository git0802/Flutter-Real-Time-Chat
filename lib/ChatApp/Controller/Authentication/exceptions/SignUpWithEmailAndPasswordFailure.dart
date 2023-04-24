class SignUpWithEmailAndPasswordFailure {
  final String message;

  SignUpWithEmailAndPasswordFailure(
      {this.message = 'An unknown error occurred'});

  factory SignUpWithEmailAndPasswordFailure.code(String code){
    switch(code){
      case '' : return SignUpWithEmailAndPasswordFailure(message: '');
      case 'invalid-password' : return SignUpWithEmailAndPasswordFailure(message: 'Email is not valid or badly formatted');
      case 'weak-password' : return SignUpWithEmailAndPasswordFailure(message: 'Please enter a stronger password');
      case 'email-already-in-use' : return SignUpWithEmailAndPasswordFailure(message: 'An account already exists for that email');
      case 'operation-not-allowed' : return SignUpWithEmailAndPasswordFailure(message: 'Operation is not allowed, please contact support');
      case 'user-disabled' : return SignUpWithEmailAndPasswordFailure(message: 'This user has been disabled, Please contact support for help.');
      default : return SignUpWithEmailAndPasswordFailure();
    }
  }
}
