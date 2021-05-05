import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthenticationService{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  User get currentUser => _auth.currentUser;

  Future<String>login(String email,String password) async{
    final result=await _auth.signInWithEmailAndPassword(email: email, password: password);
    return result.user.uid;
    }



    Future<String>register(String email,String password) async{
    final result=await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return result.user.uid;
    }



    Future<void>signOut() {

    return _auth.signOut();
    }


}