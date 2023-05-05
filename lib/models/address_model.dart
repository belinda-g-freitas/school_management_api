import 'dart:convert';

class Address {
  Address({required this.id, required this.name, this.longitude, this.latitude});

  final int id;
  final String name;
  final double? longitude;
  final double? latitude;

  Address copyWith({int? id, String? name, double? longitude, double? latitude}) {
    return Address(
      id: id ?? this.id,
      name: name ?? this.name,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'longitude': longitude, 'latitude': latitude};
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      longitude: map['longitude']?.toDouble() ?? 0.0,
      latitude: map['latitude']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Address.fromJson(String source) => Address.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Address(id: $id, name: $name, longitude: $longitude, latitude: $latitude)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Address && other.id == id && other.name == name && other.longitude == longitude && other.latitude == latitude;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ longitude.hashCode ^ latitude.hashCode;
  }
}
