import 'package:flutter/material.dart';

class RekapResiTab extends StatelessWidget {
  const RekapResiTab({super.key});

  static const _shipments = [
    ('CF-240801', 'Colt Diesel', 'Jakarta', 'Terkirim'),
    ('CF-240802', 'Fuso', 'Bandung', 'Dalam perjalanan'),
    ('CF-240803', 'Tronton', 'Surabaya', 'Menunggu muat'),
    ('CF-240804', 'Fuso', 'Semarang', 'Terkirim'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Surat jalan terbaru',
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 5),
          const Text('Ringkasan manifest operasional hari ini.'),
          const SizedBox(height: 16),
          Card(
            clipBehavior: Clip.antiAlias,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 22,
                headingRowColor: const WidgetStatePropertyAll(
                  Color(0xFFEAF1ED),
                ),
                columns: const [
                  DataColumn(label: Text('No. Resi')),
                  DataColumn(label: Text('Armada')),
                  DataColumn(label: Text('Tujuan')),
                  DataColumn(label: Text('Status')),
                ],
                rows: [
                  for (final shipment in _shipments)
                    DataRow(
                      cells: [
                        DataCell(Text(shipment.$1)),
                        DataCell(Text(shipment.$2)),
                        DataCell(Text(shipment.$3)),
                        DataCell(_StatusLabel(status: shipment.$4)),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusLabel extends StatelessWidget {
  const _StatusLabel({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final isComplete = status == 'Terkirim';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isComplete ? Icons.check_circle : Icons.schedule,
          size: 15,
          color: isComplete ? const Color(0xFF176B5B) : const Color(0xFFB36B08),
        ),
        const SizedBox(width: 6),
        Text(status),
      ],
    );
  }
}
