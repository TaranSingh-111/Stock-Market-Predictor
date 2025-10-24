import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController{
  final FirebaseAuth _auth =  FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Rx<User?> firebaseUser = Rx<User?>(null);
  var isLoading = false.obs;

  @override
  void onReady(){
    super.onReady();
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  void _setInitialScreen(User? user){
    if(user == null){
      Get.offAllNamed('/login');
    }
    else{
      Get.offAllNamed('/main');
    }
  }



  Future<void> signInWithGoogle() async{
    try{
      isLoading.value = true;
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if(googleUser == null){
        isLoading.value = false;
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
      );

      await _auth.signInWithCredential(credential);
      Get.offAllNamed('/main');
    }
    catch(e){
      Get.snackbar('Error', e.toString());
    }
    finally{
      isLoading.value = false;
    }
  }

  Future<void> signOut() async{
    try{
      await _googleSignIn.signOut();
      await _auth.signOut();
      print('user signed out');
    }
    catch (e){
      print('Sign-out error: $e');
    }
  }
}