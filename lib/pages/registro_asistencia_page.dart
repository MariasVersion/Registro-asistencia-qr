import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'asistencias_table_page.dart';
import '../main.dart';

class RegistroAsistenciaPage extends StatefulWidget {
  final String evento;

  const RegistroAsistenciaPage({super.key, required this.evento});

  @override
  State<RegistroAsistenciaPage> createState() => _RegistroAsistenciaPageState();
}

class _RegistroAsistenciaPageState extends State<RegistroAsistenciaPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _cargoController = TextEditingController();
  late SignatureController _firmaController;
  Uint8List? _firmaImagen;

  @override
  void initState() {
    super.initState();
    _firmaController = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
  }

  @override
  void dispose() {
    _firmaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventoInfo = widget.evento
        .replaceAll("{", "")
        .replaceAll("}", "")
        .split(",")
        .map((e) => e.split(":"))
        .fold<Map<String, String>>({}, (map, pair) {
      if (pair.length == 2) {
        map[pair[0].trim()] = pair[1].trim();
      }
      return map;
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Registro de Asistencia")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "Datos del Evento:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("Evento: ${eventoInfo['nombreEvento'] ?? ''}"),
              Text("Proceso: ${eventoInfo['proceso'] ?? ''}"),
              Text("Fecha: ${eventoInfo['fecha'] ?? ''}"),
              const SizedBox(height: 20),

              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: "Nombre"),
                validator: (value) => value!.isEmpty ? "Campo obligatorio" : null,
              ),
              TextFormField(
                controller: _cedulaController,
                decoration: const InputDecoration(labelText: "Cédula"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Campo obligatorio" : null,
              ),
              TextFormField(
                controller: _cargoController,
                decoration: const InputDecoration(labelText: "Cargo"),
                validator: (value) => value!.isEmpty ? "Campo obligatorio" : null,
              ),

              const SizedBox(height: 20),
              const Text(
                "Firma digital:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 150,
                child: Signature(
                  controller: _firmaController,
                  backgroundColor: Colors.grey[200]!,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => _firmaController.clear(),
                    child: const Text("Limpiar Firma"),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _registrarAsistencia,
                icon: const Icon(Icons.save),
                label: const Text("Guardar Asistencia"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _registrarAsistencia() async {
    if (_formKey.currentState!.validate()) {
      if (_firmaController.isNotEmpty) {
        final firmaBytes = await _firmaController.toPngBytes();
          Asistencia(
            nombre: _nombreController.text,
            cedula: _cedulaController.text,
            cargo: _cargoController.text,
            firma: firmaBytes!,
          ),
        );

        setState(() {
          _firmaImagen = firmaBytes;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Asistencia registrada con éxito.")),
        );

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Por favor firma antes de continuar.")),
        );
      }
    }
  }
}
