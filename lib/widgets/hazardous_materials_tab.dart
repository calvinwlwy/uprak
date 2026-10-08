import 'package:flutter/material.dart';

class HazardousMaterialsTab extends StatefulWidget {
  const HazardousMaterialsTab({super.key});

  @override
  State<HazardousMaterialsTab> createState() => _HazardousMaterialsTabState();
}

class _HazardousMaterialsTabState extends State<HazardousMaterialsTab> {
  final List<bool> _expanded = [false, false, false, false];

  static const _guides = [
    (
      'Bahan mudah terbakar',
      'Jauhkan dari sumber panas dan percikan api. Pastikan kemasan tertutup rapat, tegak, serta memiliki label bahaya yang terlihat.',
      Icons.local_fire_department_outlined,
    ),
    (
      'Bahan korosif',
      'Gunakan wadah tahan korosi dan alas penahan tumpahan. Pisahkan dari bahan yang dapat bereaksi dan hindari kontak langsung.',
      Icons.science_outlined,
    ),
    (
      'Gas bertekanan',
      'Amankan tabung dalam posisi tegak dengan pengikat yang sesuai. Lindungi katup dan pastikan ventilasi kendaraan berfungsi.',
      Icons.propane_tank_outlined,
    ),
    (
      'Bahan berbahaya bagi lingkungan',
      'Cegah kebocoran selama perjalanan. Siapkan perlengkapan penanganan tumpahan dan ikuti prosedur pelaporan insiden.',
      Icons.eco_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFB36B08),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Periksa dokumen keselamatan dan label muatan sebelum kendaraan diberangkatkan.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        ExpansionPanelList(
          elevation: 0,
          expandedHeaderPadding: EdgeInsets.zero,
          expansionCallback: (index, isExpanded) {
            setState(() => _expanded[index] = isExpanded);
          },
          children: [
            for (var index = 0; index < _guides.length; index++)
              ExpansionPanel(
                canTapOnHeader: true,
                isExpanded: _expanded[index],
                headerBuilder: (context, isExpanded) => ListTile(
                  leading: Icon(
                    _guides[index].$3,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(
                    _guides[index].$1,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.fromLTRB(72, 0, 20, 18),
                  child: Text(_guides[index].$2),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
