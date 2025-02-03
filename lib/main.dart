import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart'; // 권한 패키지

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QRViewExample(),
    );
  }
}

class QRViewExample extends StatefulWidget {
  const QRViewExample({super.key});

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  String? qrText = "Scan a QR code";
  MobileScannerController cameraController = MobileScannerController();

  @override
  void initState() {
    super.initState();
    // 카메라 권한 요청
    _requestCameraPermission();
  }

  // 카메라 권한 요청 함수
  Future<void> _requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.request();

    if (status.isGranted) {
      print('Camera permission granted');
    } else if (status.isDenied) {
      print('Camera permission denied');
    } else if (status.isPermanentlyDenied) {
      openAppSettings(); // 사용자가 권한을 영구적으로 거부한 경우 앱 설정을 열어서 권한을 수정할 수 있도록 유도
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR Code Scanner')),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: MobileScanner(
              controller: cameraController,
              onDetect: (barcode, args) {
                final String code = barcode.rawValue ?? 'Unknown';
                setState(() {
                  qrText = code;
                });
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (qrText != null)
                  ? Text('Scan result: $qrText')
                  : Text('Scan a code'),
            ),
          ),
        ],
      ),
    );
  }
}
