


import 'dart:convert';

import 'package:school_management_frog/models/address_model.dart';

class Person {
  final int id;
  final String firstname;
  final String lastname;
  final String reference;
  final String gender;
  final String email;
  final String password;
  final Address address;
  final String degree;
  final String dateOfBirth; 
  final bool deactivated;
  final String createdAt;
  final String updatedAt;
  final String profession;
  final String access;
  final String civility;
  
  Person({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.reference,
    required this.gender,
    required this.email,
    required this.password,
    required this.address,
    required this.degree,
    required this.dateOfBirth,
    required this.deactivated,
    required this.createdAt,
    required this.	updatedAt,
    required this.profession,
    required this.access,
    required this.civility,
  });

  Person copyWith({
    int? id,
    String? firstname,
    String? lastname,
    String? reference,
    String? gender,
    String? email,
    String? password,
    Address? address,
    String? degree,
    String? dateOfBirth,
    bool? deactivated,
    String? createdAt,
    String? 	updatedAt,
    String? profession,
    String? access,
    String? civility,
  }) {
    return Person(
      id: id ?? this.id,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      reference: reference ?? this.reference,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      password: password ?? this.password,
      address: address ?? this.address,
      degree: degree ?? this.degree,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      deactivated: deactivated ?? this.deactivated,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: 	updatedAt ?? this.	updatedAt,
      profession: profession ?? this.profession,
      access: access ?? this.access,
      civility: civility ?? this.civility,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'reference': reference,
      'gender': gender,
      'email': email,
      'password': password,
      'address': address.toMap(),
      'degree': degree,
      'dateOfBirth': dateOfBirth,
      'deactivated': deactivated,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'profession': profession,
      'access': access,
      'civility': civility,
    };
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      id: map['id']?.toInt() ?? 0,
      firstname: map['firstname'] ?? '',
      lastname: map['lastname'] ?? '',
      reference: map['reference'] ?? '',
      gender: map['gender'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      address: Address.fromMap(map['address']),
      degree: map['degree'] ?? '',
      dateOfBirth: map['date_of_birth'] ?? '',
      deactivated: map['deactivated'] ?? false,
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
      profession: map['profession'] ?? '',
      access: map['access'] ?? '',
      civility: map['civility'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Person.fromJson(String source) => Person.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Person(id: $id, firstname: $firstname, lastname: $lastname, reference: $reference, gender: $gender, email: $email, password: $password, address: $address, degree: $degree, dateOfBirth: $dateOfBirth, deactivated: $deactivated, createdAt: $createdAt, 	updatedAt: $updatedAt, profession: $profession, access: $access, civility: $civility)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Person &&
      other.id == id &&
      other.firstname == firstname &&
      other.lastname == lastname &&
      other.reference == reference &&
      other.gender == gender &&
      other.email == email &&
      other.password == password &&
      other.address == address &&
      other.degree == degree &&
      other.dateOfBirth == dateOfBirth &&
      other.deactivated == deactivated &&
      other.createdAt == createdAt &&
      other.	updatedAt == 	updatedAt &&
      other.profession == profession &&
      other.access == access &&
      other.civility == civility;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      firstname.hashCode ^
      lastname.hashCode ^
      reference.hashCode ^
      gender.hashCode ^
      email.hashCode ^
      password.hashCode ^
      address.hashCode ^
      degree.hashCode ^
      dateOfBirth.hashCode ^
      deactivated.hashCode ^
      createdAt.hashCode ^
      	updatedAt.hashCode ^
      profession.hashCode ^
      access.hashCode ^
      civility.hashCode;
  }
}
