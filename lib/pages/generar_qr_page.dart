import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerarQrPage extends StatelessWidget {
  final String nombreEvento;
  final String proceso;
  final DateTime fecha;

  const GenerarQrPage({
    super.key,
    required this.nombreEvento,
    required this.proceso,
    required this.fecha,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> eventoData = {
      'nombreEvento': nombreEvento,
      'proceso': proceso,
      'fecha': fecha.toIso8601String(),
    };

    final String qrData = eventoData.toString();

    return Scaffold(
      appBar: AppBar(title: const Text("Código QR del Evento")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                "Evento: $nombreEvento",
                style: const TextStyle(fontSize: 16),
              ),
              Text("Proceso: $proceso"),
              Text("Fecha: ${fecha.toLocal().toString().split(' ')[0]}"),
              const SizedBox(height: 30),
              QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 250.0,
              ),
              const SizedBox(height: 20),
              const Text(
                "Este es el código QR que deben escanear los asistentes.",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
