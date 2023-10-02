import 'dart:developer';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

class Payment {
  final String apiUrl =
      'https://checkout-sandbox.payway.com.kh/api/payment-gateway/v1/payments/purchase';
  final String apiKey = 'e2f18ec6-462a-4fab-816b-9a3630a82e18';
  final String merchantId = 'measmeta';

  void initiatePayment() async {
    const String apiKey = 'e2f18ec6-462a-4fab-816b-9a3630a82e18';
    final String transactionId = DateTime.now()
        .millisecondsSinceEpoch
        .toString(); // Replace with your ABA Payway API key
    const String apiUrl =
        'https://checkout-sandbox.payway.com.kh/api/payment-gateway/v1/payments/purchase';
    final reqTime = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
    const String amount = '2.00';
    const String firstName = 'Sonita';
    const String lastName = 'Thorn';
    const String phone = '+85515200361';
    const String email = 'thorn.sonita@ababank.com';
    const String paymentOption = 'abapay_khqr';

    final hashStr =
        '$reqTime$merchantId$transactionId$amount$firstName$lastName$email$phone$paymentOption';
    final hash = _getHash(hashStr);
    final Map<String, dynamic> requestData = {
      'hash': hash,
      'tran_id': transactionId,
      'amount': amount,
      'firstname': firstName,
      'lastname': lastName,
      'phone': phone,
      'email': email,
      'req_time': reqTime,
      'merchant_id': 'measmeta',
      'payment_option': 'abapay__khqr_deeplink',
    };

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(requestData),
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final paymentURL = responseData['payment_url'];
        log(paymentURL);
      } else {}
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> handleCheckout() async {
    final String transactionId =
        DateTime.now().millisecondsSinceEpoch.toString();
    const String amount = '2.00';
    const String firstName = 'Sonita';
    const String lastName = 'Thorn';
    const String phone = '+85515200361';
    const String email = 'thorn.sonita@ababank.com';
    const String paymentOption = 'abapay_khqr';

    final reqTime = DateFormat('yyyyMMddHHmmss').format(DateTime.now());

    print(reqTime);

    final hashStr =
        '$reqTime$merchantId$transactionId$amount$firstName$lastName$email$phone$paymentOption';
    final hash = _getHash(hashStr);
    final Uri uri = Uri.parse(apiUrl);
    try {
      final Map<String, String> fields = {
        'hash': hash,
        'tran_id': transactionId,
        'amount': amount,
        'firstname': firstName,
        'lastname': lastName,
        'phone': phone,
        'email': email,
        'req_time': reqTime.toString(),
        'merchant_id': merchantId,
        'payment_option': paymentOption,
        'language': 'en',
        'type': 'pre-auth'
      };
      final request = http.MultipartRequest('POST', uri)..fields.addAll(fields);

      final response = await request.send();
      final responseStream =
          await response.stream.toBytes(); // Read the response content as bytes
      final responseText = utf8.decode(responseStream);
      log(responseText);
      print(response.statusCode);
      if (response.statusCode == 302) {
        print(request.fields);
      } else {}
    } catch (e) {
      log(e.toString());
    }
  }

  String _getHash(String hashStr) {
    final key = utf8.encode(apiKey);
    final data = utf8.encode(hashStr);

    final hmacSha512 = Hmac(sha512, key);
    final digest = hmacSha512.convert(data);

    return base64Encode(digest.bytes);
  }
}
