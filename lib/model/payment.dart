// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PaymentModel {
  String? code;
  String? message;
  String? tran_id;
  String? description;
  String? qr_string;
  String? abapay_deeplink;
  String? checkout_qr_url;
  PaymentModel({
    this.code,
    this.message,
    this.tran_id,
    this.description,
    this.qr_string,
    this.abapay_deeplink,
    this.checkout_qr_url,
  });

  PaymentModel copyWith({
    String? code,
    String? message,
    String? tran_id,
    String? description,
    String? qr_string,
    String? abapay_deeplink,
    String? checkout_qr_url,
  }) {
    return PaymentModel(
      code: code ?? this.code,
      message: message ?? this.message,
      tran_id: tran_id ?? this.tran_id,
      description: description ?? this.description,
      qr_string: qr_string ?? this.qr_string,
      abapay_deeplink: abapay_deeplink ?? this.abapay_deeplink,
      checkout_qr_url: checkout_qr_url ?? this.checkout_qr_url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'message': message,
      'tran_id': tran_id,
      'description': description,
      'qr_string': qr_string,
      'abapay_deeplink': abapay_deeplink,
      'checkout_qr_url': checkout_qr_url,
    };
  }

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      code: map['code'] != null ? map['code'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      tran_id: map['tran_id'] != null ? map['tran_id'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      qr_string: map['qr_string'] != null ? map['qr_string'] as String : null,
      abapay_deeplink: map['abapay_deeplink'] != null ? map['abapay_deeplink'] as String : null,
      checkout_qr_url: map['checkout_qr_url'] != null ? map['checkout_qr_url'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentModel.fromJson(String source) => PaymentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PaymentModel(code: $code, message: $message, tran_id: $tran_id, description: $description, qr_string: $qr_string, abapay_deeplink: $abapay_deeplink, checkout_qr_url: $checkout_qr_url)';
  }

  @override
  bool operator ==(covariant PaymentModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.code == code &&
      other.message == message &&
      other.tran_id == tran_id &&
      other.description == description &&
      other.qr_string == qr_string &&
      other.abapay_deeplink == abapay_deeplink &&
      other.checkout_qr_url == checkout_qr_url;
  }

  @override
  int get hashCode {
    return code.hashCode ^
      message.hashCode ^
      tran_id.hashCode ^
      description.hashCode ^
      qr_string.hashCode ^
      abapay_deeplink.hashCode ^
      checkout_qr_url.hashCode;
  }
}
