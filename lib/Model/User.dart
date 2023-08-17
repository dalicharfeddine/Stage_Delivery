import 'dart:ffi';
import 'dart:io';

class User {
  Int id;
  String name;
  String userName;
  String password;
  String email;
  String image;
  String phone;
  String address;
  String type;
  String status;
  String staffId;
  String plateNo;
  String bankStatement;
  Int hubId;
  Int carId;
  String cinCopy;
  String cin;

  User({
    required this.id,
    required this.name,
    required this.userName,
    required this.password,
    required this.email,
    required this.image,
    required this.phone,
    required this.address,
    required this.type,
    required this.status,
    required this.staffId,
    required this.plateNo,
    required this.bankStatement,
    required this.hubId,
    required this.carId,
    required this.cinCopy,
    required this.cin,
  });
}
