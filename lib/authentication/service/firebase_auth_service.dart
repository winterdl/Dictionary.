import 'package:dictionary/favorite_words/model/favorite_words_model.dart';
import 'package:dictionary/authentication/model/user_data_model.dart';
import 'package:dictionary/authentication/repository/user_repository.dart';
import 'package:dictionary/authentication/utils/firebase_exceptions_valid.dart';
import 'package:dictionary/favorite_words/repository/favorite_words_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class UserRepository {
  Future signInWithCredentials(String email, String password);

  singUp(String email, String password, String name);

  Future<User?> signInWithGoogle();

  Future<User?> signInWithFacebook();

  Future signOut();

  Future<bool> isSignedIn();

  Future<User?> getUser();
}

class UserRepositoryImpl implements UserRepository {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  FireUsersDataRepoImpl _fireUsersDataRepo = FireUsersDataRepoImpl();
  FireFavWordsRepoImpl _fireFavWordsRepoImpl = FireFavWordsRepoImpl();

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future signInWithCredentials(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print(userCredential);
    } on FirebaseAuthException catch (e) {
      checkError(e.code);
    }
  }

  Future<void> singUp(String email, String name, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      print(userCredential);
      User? user = userCredential.user;
      print('User: $user');
      _createNewUser(user, name);
    } on FirebaseAuthException catch (e) {
      checkError(e.code);
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<User?> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? _user;
    final UserCredential _userCredential;
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        _userCredential = await auth.signInWithCredential(credential);
        _user = _userCredential.user;
        _createNewUser(_user);
      } on FirebaseAuthException catch (e) {
        checkError(e.code);
      } catch (e) {
        print(e);
        return Future.error(e);
      }
    }

    return _user;
  }

  Future<User?> signInWithFacebook() async {
    User? _user;
    final LoginResult loginResult = await FacebookAuth.instance.login();
    // Cre{ate a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    try {
      UserCredential _userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
      _user = _userCredential.user;

      _createNewUser(_user);
    } on FirebaseAuthException catch (e) {
      checkError(e.code);
    } catch (e) {
      print(e);
      return Future.error(e);
    }
    return _user;
  }

  Future signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      googleSignIn.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<User?> getUser() async {
    return _firebaseAuth.currentUser;
  }

  _createNewUser(User? user, [String? name]) async {
    UserData? _userData;
    FavoriteWords? _favoriteWords;
    if (user != null) {
      final UserData? _getUser = await _fireUsersDataRepo.getUser(user.uid);
      print(user.email);
      if (_getUser == null) {
        print(_getUser);
        _userData = UserData(
            uid: user.uid,
            name: name ?? user.displayName!,
            email: user.email!,);

        _favoriteWords = FavoriteWords(words: [], uid: _userData.uid);
        _fireUsersDataRepo.setUser(_userData);
        _fireFavWordsRepoImpl.setFavoriteWord(_favoriteWords);
      }
    }
  }
}