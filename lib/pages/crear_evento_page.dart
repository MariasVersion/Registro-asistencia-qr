import 'package:flutter/material.dart';
import 'generar_qr_page.dart';

class CrearEventoPage extends StatefulWidget {
  const CrearEventoPage({super.key});

  @override
  State<CrearEventoPage> createState() => _CrearEventoPageState();
}

class _CrearEventoPageState extends State<CrearEventoPage> {
  final TextEditingController _nombreEventoController = TextEditingController();
  final TextEditingController _procesoController = TextEditingController();
  DateTime? _fechaEvento;

  void _seleccionarFecha() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaEvento ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _fechaEvento) {
      setState(() {
        _fechaEvento = picked;
      });
    }
  }

  void _generarQR() {
    if (_nombreEventoController.text.isNotEmpty &&
        _procesoController.text.isNotEmpty &&
        _fechaEvento != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => GenerarQrPage(
            nombreEvento: _nombreEventoController.text,
            proceso: _procesoController.text,
            fecha: _fechaEvento!,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crear Evento")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nombreEventoController,
              decoration: const InputDecoration(labelText: "Nombre del Evento"),
            ),
            TextField(
              controller: _procesoController,
              decoration: const InputDecoration(labelText: "Proceso a Cargo"),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  _fechaEvento == null
                      ? "Selecciona una fecha"
                      : "Fecha: ${_fechaEvento!.toLocal().toString().split(' ')[0]}",
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _seleccionarFecha,
                  child: const Text("Seleccionar Fecha"),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.qr_code),
              label: const Text("Generar QR"),
              onPressed: _generarQR,
            ),
          ],
        ),
      ),
    );
  }
}
