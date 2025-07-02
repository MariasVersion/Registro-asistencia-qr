import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// MODELO DE DATOS
class Asistencia {
  final String nombre;
  final String cedula;
  final String cargo;
  final Uint8List firma;

  Asistencia({
    required this.nombre,
    required this.cedula,
    required this.cargo,
    required this.firma,
  });
}

// VISTA DE TABLA
class AsistenciasTablePage extends StatelessWidget {
  final List<Asistencia> registros;

  const AsistenciasTablePage({super.key, required this.registros});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Asistencias Registradas")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: registros.isEmpty
            ? const Center(child: Text("No hay registros aún."))
            : Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Nombre")),
                    DataColumn(label: Text("Cédula")),
                    DataColumn(label: Text("Cargo")),
                    DataColumn(label: Text("Firma")),
                  ],
                  rows: registros.map((a) {
                    return DataRow(cells: [
                      DataCell(Text(a.nombre)),
                      DataCell(Text(a.cedula)),
                      DataCell(Text(a.cargo)),
                      DataCell(Image.memory(a.firma, width: 80, height: 40)),
                    ]);
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _exportarPDF(context),
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text("Exportar PDF"),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Exportar a Excel
                  },
                  icon: const Icon(Icons.table_chart),
                  label: const Text("Exportar Excel"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // FUNCIÓN PARA EXPORTAR A PDF
  void _exportarPDF(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text("Registro de Asistencias", style: pw.TextStyle(fontSize: 20)),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            headers: ["Nombre", "Cédula", "Cargo"],
            data: registros
                .map((a) => [a.nombre, a.cedula, a.cargo])
                .toList(),
          ),
          pw.SizedBox(height: 20),
          pw.Text("Firmas:", style: pw.TextStyle(fontSize: 16)),
          pw.Wrap(
            spacing: 10,
            runSpacing: 10,
            children: registros.map((a) {
              return pw.Column(children: [
                pw.Text(a.nombre, style: pw.TextStyle(fontSize: 10)),
                pw.Image(pw.MemoryImage(a.firma), width: 100, height: 40),
              ]);
            }).toList(),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}
