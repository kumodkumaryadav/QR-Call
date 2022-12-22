import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:torch_light/torch_light.dart';
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
        // ignore: no_leading_underscores_for_local_identifiers
        String? _result=result!.code;
        if(_result!.contains("tel:")){
          _result=_result.substring(4);
        }
        debugPrint("*******************************************");
        debugPrint("*******************************************");
        debugPrint("*******************************************");
        debugPrint(_result);
        debugPrint("*******************************************");
        debugPrint("*******************************************");
        debugPrint("*******************************************");
        if (_result.length >= 10 && _result.length<=13) {
          var url = Uri.parse("tel:$_result");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: const Duration(seconds: 3),
              content: Center(child: Text("Calling $_result"))));

          Future.delayed(const Duration(seconds: 3), () {
            // Do something
            launchUrl(url);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                duration: Duration(seconds: 5),
                content: Center(child: Text("This QR don't have any Valid Calling Number!"))));
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
        // Positioned(
        //     bottom: 200,
        //     right: 150,
        //     child: Row(
        //       children: [
                
        //          IconButton(onPressed: () {
        //         TorchLight.disableTorch();
                  
        //         }, icon: Icon(Icons.flashlight_off,color: Colors.white,)),
        //         IconButton(onPressed: () {
        //         TorchLight.enableTorch();
                  
        //         }, icon: Icon(Icons.flashlight_on, color: Colors.white,)),
        //       ],
        //     ))
      ]),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
