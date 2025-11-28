

class Administrador {
  final String uid;
  final String nome;
  final String email;
  final String senha;
  final String funcao; 
  final String role;
  final bool autorizado;

  const Administrador({required this.uid, required this.nome, required this.email, required this.role, required this.senha, required this.funcao, required this.autorizado });

  Map<String, dynamic> toMap(){
    return{
      "nome": nome,
      "email": email,
      "senha":senha,
      "funcao": funcao,
      "role": role, 
      "autorizado": autorizado,
    };
  }

  factory Administrador.fromMap(Map<String, dynamic> map, String uid) {
    return Administrador(
      uid: uid,
      nome: map['nome'] ?? '',
      email : map['email'] ?? '',
      senha: map['senha'] ?? '',
      funcao: map['funcao'] ?? '',
      role: map['role'] ?? '',
      autorizado: map['autorizado'] ?? false,
    );
  }
}