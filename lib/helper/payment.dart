import 'dart:math';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';

class Payment {
  final String apiUrl =
      'https://checkout.payway.com.kh/api/payment-gateway/v1/payments/purchase';
  final String apiKey = 'e2f18ec6-462a-4fab-816b-9a3630a82e18';
  final String merchantId = 'measmeta';

  Future<void> sendPaymentRequest(
      {required req_time,
      required tran_id,
      required firstname,
      required lastname,
      required email,
      required phone,
      required amount,
      required return_url,
      required continue_success_url,
      required return_params,
      required view_type,
      required payment_option}) async {
    final url = Uri.parse(
        "https://checkout-sandbox.payway.com.kh/api/payment-gateway/v1/payments/purchase");

    String hashMsg =
        "$req_time$merchantId$tran_id$firstname$lastname$email$phone$amount$payment_option$return_url$continue_success_url$return_params$view_type";
    String secret = 'e2f18ec6-462a-4fab-816b-9a3630a82e18';

    List<int> hashUnEnc =
        Hmac(sha512, utf8.encode(secret)).convert(utf8.encode(hashMsg)).bytes;
    String hashV = base64.encode(hashUnEnc);

    print(hashV.toString() + 'hash');

    final Map<String, String> requestBody = {
      'req_time': req_time,
      'merchant_id': merchantId,
      'tran_id': tran_id,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'phone': phone,
      'amount': amount,
      'type': 'purchase',
      'payment_option': payment_option,
      'return_url': return_url,
      'continue_success_url': continue_success_url,
      'return_params': return_params,
      'view_type': view_type,
      'hash': hashV,
    };

    final response = await http.post(
      url,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      print('Request successful');
      print('Response: ${response.body}');
      // You can handle the response here
    } else {
      print('Request failed with status code: ${response.statusCode}');
      print('Response: ${response.body}');
      // You can handle errors here
    }
  }

  String getHash({required String hashStr, required String apiKey}) {
    List<int> hmac =
        Hmac(sha512, utf8.encode(apiKey)).convert(utf8.encode(hashStr)).bytes;
    String hash = base64Encode(hmac);
    return hash;
  }
}
