// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  String? email;
  String? name;
  String? password;
  String? profilePic;
  String? token;
  String? uid;
  String? phoneNumber;
  String? payStatus;
  String? payDate;
  String? expireDate;
  UserModel({
    this.email,
    this.name,
    this.password,
    this.profilePic,
    this.token,
    this.uid,
    this.phoneNumber,
    this.payStatus,
    this.payDate,
    this.expireDate,
  });

  UserModel copyWith({
    String? email,
    String? name,
    String? password,
    String? profilePic,
    String? token,
    String? uid,
    String? phoneNumber,
    String? payStatus,
    String? payDate,
    String? expireDate,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      password: password ?? this.password,
      profilePic: profilePic ?? this.profilePic,
      token: token ?? this.token,
      uid: uid ?? this.uid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      payStatus: payStatus ?? this.payStatus,
      payDate: payDate ?? this.payDate,
      expireDate: expireDate ?? this.expireDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'password': password,
      'profilePic': profilePic,
      'token': token,
      'uid': uid,
      'phoneNumber': phoneNumber,
      'payStatus': payStatus,
      'payDate': payDate,
      'expireDate': expireDate,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] != null ? map['email'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      profilePic:
          map['profilePic'] != null ? map['profilePic'] as String : null,
      token: map['token'] != null ? map['token'] as String : null,
      uid: map['uid'] != null ? map['uid'] as String : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      payStatus: map['payStatus'] != null ? map['payStatus'] as String : null,
      payDate: map['payDate'] != null ? map['payDate'] as String : null,
      expireDate:
          map['expireDate'] != null ? map['expireDate'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(email: $email, name: $name, password: $password, profilePic: $profilePic, token: $token, uid: $uid, phoneNumber: $phoneNumber, payStatus: $payStatus, payDate: $payDate, expireDate: $expireDate)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.email == email &&
        other.name == name &&
        other.password == password &&
        other.profilePic == profilePic &&
        other.token == token &&
        other.uid == uid &&
        other.phoneNumber == phoneNumber &&
        other.payStatus == payStatus &&
        other.payDate == payDate &&
        other.expireDate == expireDate;
  }

  @override
  int get hashCode {
    return email.hashCode ^
        name.hashCode ^
        password.hashCode ^
        profilePic.hashCode ^
        token.hashCode ^
        uid.hashCode ^
        phoneNumber.hashCode ^
        payStatus.hashCode ^
        payDate.hashCode ^
        expireDate.hashCode;
  }
}
