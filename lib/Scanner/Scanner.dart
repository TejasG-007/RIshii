import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pockettouristguide/WebView.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


class Scanner extends StatefulWidget {
  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {

  final GlobalKey scankey = GlobalKey(debugLabel: 'OR');
  Barcode result;
  QRViewController controller;
  List<dynamic> lastSeareched= [];

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) {
      FirebaseFirestore.instance.collection("users").doc("${FirebaseAuth.instance.currentUser.email}").set(
          {"Recent Searches": lastSeareched.toSet().toList()});
      setState(() {
        result = scanData;
        lastSeareched.insert(0, scanData.code);
        // print(lastSeareched);
      });
    });
  }
@override
  void initState() {
  FirebaseFirestore.instance.collection("users").doc("${FirebaseAuth.instance.currentUser.email}").get().then((value) =>lastSeareched =value.data()['Recent Searches']);
  // print(lastSeareched);
  // TODO: implement initState
    super.initState();
  }

  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();}}
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

Widget alertbox(){
    return AlertDialog(
      title: Text("Do You Want to Proceed ?",style: Theme.of(context).textTheme.headline2.copyWith(fontSize: 15,color: Colors.red)),
      actions: [
        ElevatedButton(onPressed: (){
          Navigator.push(context,MaterialPageRoute(builder: (context)=>DisplayInfo(Url:"${result.code}")));
        }, child:Text("Click to see"))
      ],
    );}
  @override
  Widget build(BuildContext context) {
    var data =  FirebaseFirestore.instance.collection("Places").get();
    print(data);
    return Scaffold(
      body: (result != null)?alertbox():Column(
        children: [
          Expanded(
            flex: 4,
            child: QRView(
              overlayMargin: EdgeInsets.all(20),
              key: scankey,
                onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.teal),
                  backgroundColor: Colors.pink,

                ),
                Text("Searching Code...",style: Theme.of(context).textTheme.headline2.copyWith(fontSize: 20,color: Colors.teal))
              ],
            ),
          )

        ],
      ),
    );
  }

}

