import 'package:flutter/material.dart';

import '../models/booking_result.dart';
import '../models/vehicle.dart';
import '../widgets/armada_tab.dart';
import '../widgets/hazardous_materials_tab.dart';
import '../widgets/informasi_depo_tab.dart';
import '../widgets/rekap_resi_tab.dart';
import 'cargo_booking_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  static const _titles = ['Manifes Muatan', 'Rekap Resi', 'Informasi Depo'];

  Future<void> _openBooking(Vehicle vehicle) async {
    final issued = await Navigator.of(context).push<BookingResult>(
      MaterialPageRoute<BookingResult>(
        builder: (_) => CargoBookingScreen(vehicle: vehicle),
      ),
    );

    if (!mounted || issued == null) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${issued.status}: ${issued.receiptNumber}'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF176B5B),
        ),
      );
  }

  Widget _buildManifest() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Material(
            color: Colors.white,
            child: TabBar(
              tabs: const [
                Tab(text: 'Armada Tersedia'),
                Tab(text: 'Syarat Muatan Berbahaya'),
              ],
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: const Color(0xFF65716C),
              indicatorSize: TabBarIndicatorSize.label,
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                ArmadaTab(onSelectVehicle: _openBooking),
                const HazardousMaterialsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage() {
    switch (_selectedIndex) {
      case 1:
        return const RekapResiTab();
      case 2:
        return const InformasiDepoTab();
      default:
        return _buildManifest();
    }
  }

  void _selectPage(int index) {
    setState(() => _selectedIndex = index);
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_titles[_selectedIndex]),
            const Text(
              'CARGOFLOW  /  OPERASIONAL',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
                color: Color(0xFF75817B),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Color(0xFF176B5B)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.local_shipping,
                      color: Colors.white,
                      size: 34,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'CargoFlow Logistics',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Armada operasional  •  CF-028',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.78),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.inventory_2_outlined),
                title: const Text('Manifes Muatan'),
                selected: _selectedIndex == 0,
                onTap: () => _selectPage(0),
              ),
              ListTile(
                leading: const Icon(Icons.receipt_long_outlined),
                title: const Text('Rekap Resi'),
                selected: _selectedIndex == 1,
                onTap: () => _selectPage(1),
              ),
              ListTile(
                leading: const Icon(Icons.warehouse_outlined),
                title: const Text('Informasi Depo'),
                selected: _selectedIndex == 2,
                onTap: () => _selectPage(2),
              ),
              const Spacer(),
              const Divider(height: 1),
              const ListTile(
                leading: Icon(Icons.support_agent_outlined),
                title: Text('Pusat Operasional'),
                subtitle: Text('Layanan staf lapangan'),
              ),
            ],
          ),
        ),
      ),
      body: _buildPage(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Theme.of(context).colorScheme.primary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'Manifes Muatan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Rekap Resi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warehouse_outlined),
            activeIcon: Icon(Icons.warehouse),
            label: 'Informasi Depo',
          ),
        ],
      ),
    );
  }
}
