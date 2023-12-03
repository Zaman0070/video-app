import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCode extends StatelessWidget {
  final String qrData;
  const QRCode({super.key, required this.qrData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QrImageView(
                data: '1234567890',
                version: QrVersions.auto,
                size: 200.0,
              ),
              const SizedBox(height: 20),
              Text(
                qrData,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              )
            ],
          ),
        ));
  }
}
