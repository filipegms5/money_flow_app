import 'package:meta/meta.dart';
import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  final String? nome;
  final String? email;
  final String? senha;

  User({
    this.nome,
    this.email,
    this.senha,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    nome: json["nome"],
    email: json["email"],
    senha: json["senha"],
  );

  Map<String, dynamic> toJson() => {
    "nome": nome,
    "email": email,
    "senha": senha,
  };
}