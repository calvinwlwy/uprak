import 'package:flutter/material.dart';

class InformasiDepoTab extends StatelessWidget {
  const InformasiDepoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5F0EB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.warehouse_outlined,
                    color: Color(0xFF176B5B),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Depo Utama Cakung',
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                const Text('Pusat konsolidasi dan distribusi CargoFlow'),
                const SizedBox(height: 20),
                const Divider(),
                const _InfoRow(
                  icon: Icons.location_on_outlined,
                  label: 'Alamat',
                  value: 'Jl. Raya Cakung Cilincing, Jakarta Timur',
                ),
                const _InfoRow(
                  icon: Icons.access_time,
                  label: 'Jam operasional',
                  value: 'Senin–Sabtu, 06.00–22.00 WIB',
                ),
                const _InfoRow(
                  icon: Icons.call_outlined,
                  label: 'Telepon depo',
                  value: '(021) 460 0280',
                ),
                const SizedBox(height: 8),
                const Text(
                  'KODE TRACKING API PUSAT',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF65716C),
                  ),
                ),
                const SizedBox(height: 6),
                SelectableText(
                  'CFG-API-JKT-2026-0284',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF176B5B),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 19, color: const Color(0xFF65716C)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF65716C),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(value),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
