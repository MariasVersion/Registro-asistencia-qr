import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'registro_asistencia_page.dart';

class ScannerPage extends StatelessWidget {
  const ScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Escanear Código QR")),
      body: MobileScanner(
        controller: MobileScannerController(),
        onDetect: (capture) {
          final barcode = capture.barcodes.first;
          final String? rawValue = barcode.rawValue;

          if (rawValue != null) {
            // Navega al formulario
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => RegistroAsistenciaPage(evento: rawValue),
              ),
            );
          }
        },
      ),
    );
  }
}
