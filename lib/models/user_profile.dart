class DeliveryAddress {
  final String id;
  final String label; // e.g. Home, Office, Other
  final String fullAddress;
  final String landmark;
  final String city;
  final String postalCode;
  final bool isDefault;

  const DeliveryAddress({
    required this.id,
    required this.label,
    required this.fullAddress,
    required this.landmark,
    required this.city,
    required this.postalCode,
    this.isDefault = false,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      id: json['id'] as String,
      label: json['label'] as String,
      fullAddress: json['fullAddress'] as String,
      landmark: json['landmark'] as String? ?? '',
      city: json['city'] as String,
      postalCode: json['postalCode'] as String,
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'fullAddress': fullAddress,
      'landmark': landmark,
      'city': city,
      'postalCode': postalCode,
      'isDefault': isDefault,
    };
  }
}

class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final String membershipType; // e.g. Zomato Gold Member
  final List<DeliveryAddress> savedAddresses;

  const UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    this.membershipType = 'Zomato Gold VIP',
    required this.savedAddresses,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ??
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
      membershipType:
          json['membershipType'] as String? ?? 'Zomato Gold VIP',
      savedAddresses: (json['savedAddresses'] as List<dynamic>?)
              ?.map((e) => DeliveryAddress.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'membershipType': membershipType,
      'savedAddresses': savedAddresses.map((a) => a.toJson()).toList(),
    };
  }
}
