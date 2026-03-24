class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String phone;

  const UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory UserProfile.fromMap(String uid, Map<String, dynamic> data) {
    return UserProfile(
      uid: uid,
      name: (data['name'] ?? '').toString(),
      email: (data['email'] ?? '').toString(),
      phone: (data['phone'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'phone': phone};
  }
}
