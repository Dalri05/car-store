// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import '../models/user.dart';

class AuthService extends ChangeNotifier {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  AppUser? _currentUser;
  bool _isLoading = false;

  AppUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  // TODO: Implementar quando Firebase for configurado
  /*
  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _currentUser = AppUser(
          id: user.uid,
          email: user.email ?? '',
          nome: user.displayName,
          fotoUrl: user.photoURL,
          ultimoLogin: DateTime.now(),
        );
      } else {
        _currentUser = null;
      }
      notifyListeners();
    });
  }

  Future<AppUser?> signInWithGoogle() async {
    try {
      _isLoading = true;
      notifyListeners();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = 
          await _auth.signInWithCredential(credential);
      
      final user = userCredential.user;
      if (user != null) {
        _currentUser = AppUser(
          id: user.uid,
          email: user.email ?? '',
          nome: user.displayName,
          fotoUrl: user.photoURL,
          ultimoLogin: DateTime.now(),
        );
        
        // Salvar/atualizar dados do usuário no Firestore
        await _saveUserToFirestore(_currentUser!);
      }

      return _currentUser;
    } catch (e) {
      print('Erro no login com Google: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      print('Erro ao fazer logout: $e');
      rethrow;
    }
  }

  Future<void> _saveUserToFirestore(AppUser user) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .set(user.toMap(), SetOptions(merge: true));
    } catch (e) {
      print('Erro ao salvar usuário no Firestore: $e');
    }
  }
  */

  // Métodos simulados para desenvolvimento
  Future<AppUser?> signInWithGoogle() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simular delay de rede
      await Future.delayed(const Duration(seconds: 2));

      // Simular usuário logado
      _currentUser = AppUser(
        id: 'demo_user_123',
        email: 'demo@carstore.com',
        nome: 'Usuário Demo',
        fotoUrl: null,
        ultimoLogin: DateTime.now(),
      );

      return _currentUser;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}