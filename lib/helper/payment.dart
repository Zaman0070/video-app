
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:video_app/constant/widget/loading.dart';
import 'package:video_app/model/payment.dart';
import 'package:video_app/screen/subscription/qr_code.dart';

class Payment {
  final String apiUrl =
      'https://checkout.payway.com.kh/api/payment-gateway/v1/payments/purchase';
  final String apiKey = 'e2f18ec6-462a-4fab-816b-9a3630a82e18';
  final String merchantId = 'measmeta';

  Future<PaymentModel> sendPaymentRequest(
      {required int index,
      required req_time,
      required tran_id,
      required firstname,
      required lastname,
      required email,
      required phone,
      required amount,
      required return_url,
      required continue_success_url,
      required return_params,
      required payment_option}) async {
    final url = Uri.parse(
        "https://checkout-sandbox.payway.com.kh/api/payment-gateway/v1/payments/purchase");

    String hashMsg =
        "$req_time$merchantId$tran_id$amount$firstname$lastname$email$phone$payment_option$return_url$continue_success_url$return_params";
    String secret = 'e2f18ec6-462a-4fab-816b-9a3630a82e18';

    List<int> hashUnEnc =
        Hmac(sha512, utf8.encode(secret)).convert(utf8.encode(hashMsg)).bytes;
    String hashV = base64.encode(hashUnEnc);
    try {
      SmartDialog.showLoading(
        animationBuilder: (controller, child, animationParam) {
          return Loading(
            text: 'Please wait...',
          );
        },
      );
      final Map<String, dynamic> requestBody = {
        'req_time': req_time,
        'merchant_id': merchantId,
        'tran_id': tran_id,
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'phone': phone,
        'amount': amount,
        'payment_option': payment_option,
        'return_url': return_url,
        'continue_success_url': continue_success_url,
        'return_params': return_params,
        'hash': hashV,
      };

      final response = await http.post(
        url,
        body: requestBody,
      );
      if (response.statusCode == 200) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'payDate': DateTime.now().toString(),
          'payStatus': index == 0 ? 'monthly' : 'yearly',
          'expireDate': index == 0
              ? DateTime.now().add(const Duration(days: 30)).toString()
              : DateTime.now().add(const Duration(days: 365)).toString(),
        });
        print('Request successful');
        print('Response: ${response.body}');

        SmartDialog.dismiss();
        var payment = PaymentModel.fromJson(response.body);
        Get.to(() => QRCode(
              qrData: payment.qr_string!,
            ));

        return payment;
      } else {
        Fluttertoast.showToast(msg: response.body);
        SmartDialog.dismiss();
      }
    } catch (e) {
      return PaymentModel();
    } finally {
      SmartDialog.dismiss();
      return PaymentModel();
    }
  }

  String getHash({required String hashStr, required String apiKey}) {
    List<int> hmac =
        Hmac(sha512, utf8.encode(apiKey)).convert(utf8.encode(hashStr)).bytes;
    String hash = base64Encode(hmac);
    return hash;
  }
}
