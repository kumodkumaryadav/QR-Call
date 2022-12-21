import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanQrPage extends StatefulWidget {
  const ScanQrPage({super.key});

  @override
  State<StatefulWidget> createState() => _ScanQrPageState();
}

class _ScanQrPageState extends State<ScanQrPage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  void _onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        debugPrint("*****************");
        debugPrint(result!.code);
        if (result!.code!.length == 10) {
          var url = Uri.parse("tel:${result!.code}");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: Duration(seconds: 5),
              content: Text("Calling ${result!.code}")));

          Future.delayed(Duration(seconds: 5), () {
            // Do something
            launchUrl(url);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: Duration(seconds: 5),
                content: Text("Invalid QR please try again")));
        }
        Navigator.pop(context);
      });
    });
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void readQr() async {
    if (result != null) {
      controller!.pauseCamera();
      debugPrint(result!.code);
      controller!.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    readQr();
    return Scaffold(
      body: Stack(children: [
        QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
            borderColor: Colors.orange,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: 250,
          ),
        ),
        Positioned(
            bottom: 100,
            left: 200,
            child: IconButton(
                iconSize: 24, onPressed: () {}, icon: const Icon(Icons.camera)))
      ]),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
