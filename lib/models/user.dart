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
        id: int.tryParse(json['id'].toString()) ?? 0,
        fullName: json['full_name']?.toString() ?? '',
        cellphone: json['cellphone']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'cellphone': cellphone,
        'email': email,
      };
}
