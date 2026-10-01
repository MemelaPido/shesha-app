class User {
  final int id;
  final String fullName;
  final String cellphone;
  final String email;

  const User({
    required this.id,
    required this.fullName,
    required this.cellphone,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int,
        fullName: json['full_name'] as String,
        cellphone: json['cellphone'] as String,
        email: json['email'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'cellphone': cellphone,
        'email': email,
      };
}
