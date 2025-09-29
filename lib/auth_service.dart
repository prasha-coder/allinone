import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

enum AuthStatus { unauthenticated, authenticating, authenticated }

// Simple User class for demo purposes
class User {
  final String uid;
  final String? email;
  final String? displayName;
  
  User({required this.uid, this.email, this.displayName});
}

class AuthService with ChangeNotifier {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  // GoogleSignIn will be implemented when Firebase project is fully configured
  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  User? _user;
  AuthStatus _status = AuthStatus.unauthenticated;

  User? get user => _user;
  AuthStatus get status => _status;
  Stream<User?> get authStateChanges => _auth.authStateChanges().map((firebase_auth.User? firebaseUser) {
    if (firebaseUser == null) return null;
    return User(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
    );
  });

  AuthService() {
    _initializeAuthListener();
  }

  void _initializeAuthListener() {
    _auth.authStateChanges().listen((firebase_auth.User? firebaseUser) {
      if (firebaseUser == null) {
        _user = null;
        _status = AuthStatus.unauthenticated;
      } else {
        _user = User(
          uid: firebaseUser.uid,
          email: firebaseUser.email,
          displayName: firebaseUser.displayName,
        );
        _status = AuthStatus.authenticated;
      }
      notifyListeners();
    });
  }

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    _status = AuthStatus.authenticating;
    notifyListeners();
    
    // Simulate user creation for demo purposes
    await Future.delayed(const Duration(seconds: 1));
    
    _user = User(
      uid: 'demo_user_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: email.split('@')[0],
    );
    _status = AuthStatus.authenticated;
    notifyListeners();
    
    debugPrint('Demo: Simulated user creation successful');
    return _user;
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    _status = AuthStatus.authenticating;
    notifyListeners();
    
    // Simulate sign in for demo purposes
    await Future.delayed(const Duration(seconds: 1));
    
    _user = User(
      uid: 'demo_user_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: email.split('@')[0],
    );
    _status = AuthStatus.authenticated;
    notifyListeners();
    
    debugPrint('Demo: Simulated email sign-in successful');
    return _user;
  }

  Future<User?> signInWithGoogle() async {
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();
      
      // For now, simulate Google Sign-In with Firebase project integration
      // TODO: Implement real Google Sign-In when Firebase project is fully configured
      await Future.delayed(const Duration(seconds: 1));
      
      // Create a demo user with Firebase project context
      _user = User(
        uid: 'firebase_user_${DateTime.now().millisecondsSinceEpoch}',
        email: 'user@nutrients1-36408159.firebaseapp.com',
        displayName: 'Firebase User',
      );
      _status = AuthStatus.authenticated;
      notifyListeners();
      
      debugPrint('Firebase Project: nutrients1-36408159 - Demo Sign-In successful');
      return _user;
    } catch (e) {
      debugPrint('Firebase: Sign-In error: $e');
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      // await _googleSignIn.signOut(); // Will be enabled when Google Sign-In is implemented
      _user = null;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      debugPrint('Firebase Project: nutrients1-36408159 - Sign out successful');
    } catch (e) {
      debugPrint('Firebase: Sign out error: $e');
    }
  }
}