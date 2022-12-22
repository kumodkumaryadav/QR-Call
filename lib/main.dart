
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_call/qr_view.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text("QR Call")),
        body: const BodyContent(),
      ),
    );
  }
}

class BodyContent extends StatefulWidget {
  const BodyContent({super.key});

  @override
  State<BodyContent> createState() => _BodyContentState();
}

class _BodyContentState extends State<BodyContent> {
  final TextEditingController _controller = TextEditingController();
  @override 
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
            
      
      QrImage(
        embeddedImageStyle: QrEmbeddedImageStyle(size: const Size(80, 40)),
        embeddedImage: const AssetImage("assets/qr_call.png"),
        // gapless: false,
        size: 240,
        backgroundColor: Colors.white,
        data: _controller.text),
        const SizedBox(height: 10,),
      Center(
        child: SizedBox(
          width: 300,
          child: TextField(
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.green),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.grey),
              ),
              hintText: "Enter Number to generate QR",
            ),
            
            keyboardType: TextInputType.number,
            controller: _controller,
          ),
        ),
      ),
      const SizedBox(height: 10,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          ElevatedButton
          
          (
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black
            ),
             
            
            onPressed: (){ setState(() {
              SystemChannels.textInput.invokeMethod('TextInput.hide');
            
          });}, child: const Text("Generate QR")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green
            ),
            onPressed: (() {
              SystemChannels.textInput.invokeMethod('TextInput.hide');
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ScanQrPage(),));

            
          }), child: const Text("Scan to Call",style: TextStyle(color: Colors.black),))
        ],
      ),
     
      
        ],
      ),
    );
  }
}
