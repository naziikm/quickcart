class Address {
  final String name;
  final String phone;
  final String line1;
  final String line2;
  final String city;
  final String state;
  final String zipCode;

  const Address({
    required this.name,
    required this.phone,
    required this.line1,
    required this.line2,
    required this.city,
    required this.state,
    required this.zipCode,
  });

  factory Address.fromMap(Map<String, dynamic> data) {
    return Address(
      name: (data['name'] ?? '').toString(),
      phone: (data['phone'] ?? '').toString(),
      line1: (data['line1'] ?? '').toString(),
      line2: (data['line2'] ?? '').toString(),
      city: (data['city'] ?? '').toString(),
      state: (data['state'] ?? '').toString(),
      zipCode: (data['zipCode'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'line1': line1,
      'line2': line2,
      'city': city,
      'state': state,
      'zipCode': zipCode,
    };
  }

  String get formatted {
    final line2Value = line2.trim().isEmpty ? '' : ', $line2';
    return '$line1$line2Value, $city, $state $zipCode';
  }
}
