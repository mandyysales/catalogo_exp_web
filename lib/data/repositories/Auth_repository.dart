import 'package:catalogo_exp_web/models/Administrador.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  //PARA A PROTEÇÃO DE ROTAS
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// SIGNUP
  Future<String> signup({
    required String nome,
    required String email,
    required String senha,
    required String funcao,
  }) async {
    try {
      final cred = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      final uid = cred.user!.uid;

      await _firestore.collection('users').doc(uid).set({
        'nome': nome,
        'email': email,
        'funcao': funcao,
        'autorizado': false,     // ainda não autorizado
        'role': 'normal',        // admin só manualmente
        'criadoEm': Timestamp.now(),
      });

      await _firebaseAuth.signOut();

      return uid;

    } on FirebaseAuthException catch (e) {
      //throw Exception('Erro ao cadastrar usuário: ${e.message}');
      print("🔥 ERRO REAL: $e");
      rethrow;
    } catch (e) {
      print("🔥 ERRO REAL: $e");
      //throw Exception('Erro ao cadastrar usuário: $e');
      rethrow;
    }
  }

Future<(String uid, dynamic role)> login({
  required String email,
  required String senha,
}) async {
  final credential = await _firebaseAuth.signInWithEmailAndPassword(
    email: email,
    password: senha,
  );

  final uid = credential.user!.uid;

  final doc = await _firestore.collection('users').doc(uid).get();

  if (!doc.exists) {
    await _firebaseAuth.signOut();
    throw Exception("Usuário não encontrado no banco de dados.");
  }

  final data = doc.data()!; 

  final autorizado = data['autorizado'] ?? false;

  if (!autorizado) {
    await _firebaseAuth.signOut();
    throw Exception("Seu acesso ainda não foi autorizado.");
  }

  final role = data['role'] ?? 'comum';

  return (uid, role );
}




  /// LOGOUT
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// DELETAR CONTA (para admins ou usuários autenticados)
  Future<void> deleteAccount() async {
    final user = _firebaseAuth.currentUser;

    if (user != null) {
      await user.delete();
    } else {
      throw Exception("Usuário não autenticado.");
    }
  }

  Future<void> autorizarUsuario(String uid) async {
    await _firestore.collection('users').doc(uid).update({
      'autorizado': true,
    });
  }

  Future<void> atualizarRole(String uid, String role) async {
    await _firestore.collection('users').doc(uid).update({
      'role': role,
    });
  }

  Future<void> aprovarComoAuxiliar(String uid) async {
    await _firestore.collection('users').doc(uid).update({
      'autorizado': true,
      'role': 'auxiliar', //3 tipos de role: normal(padrão), admin(com acesso ao console e todas as funcionalidades) e auxiliar(sem acesso ao console ou aprovação de users)
    });
  }

  Future<void> desautorizarUsuario(String uid) async {
    await _firestore.collection('users').doc(uid).delete();
  }


  Stream<List<Administrador>> getUsuariosPendentes() {
  return _firestore
      .collection('users')
      .where('autorizado', isEqualTo: false)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Administrador.fromMap(doc.data(), doc.id))
          .toList());
}


//Para a proteção de rotas
Future<User?> signInAnonymously() async {
  final cred = await _firebaseAuth.signInAnonymously();
  return cred.user;
}

Future<Map<String, dynamic>?> getUserData(String uid) async {
  final doc = await _firestore.collection('users').doc(uid).get();
  return doc.data();
}

Future<(bool logado, bool autorizado, String role)> getUserStatus() async {
  final user = _firebaseAuth.currentUser;

  if (user == null) {
    return (false, false, 'anon');
  }

  // Usuário anonimo
  if (user.isAnonymous) {
    return (true, false, 'anon');
  }

  // Usuário normal com registro no Firestore
  final doc = await _firestore.collection('users').doc(user.uid).get();
  if (!doc.exists) return (true, false, 'anon');

  final data = doc.data()!;
  final autorizado = (data['autorizado'] as bool?) ?? false;
  final role = (data['role'] as String?) ?? 'normal';
  return (
    true,
    autorizado,
    role,
  );
}




}
