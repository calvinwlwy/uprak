import 'package:flutter/material.dart';

import '../models/vehicle.dart';

class ArmadaTab extends StatelessWidget {
  const ArmadaTab({required this.onSelectVehicle, super.key});

  final ValueChanged<Vehicle> onSelectVehicle;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      itemCount: Vehicle.available.length,
      itemBuilder: (context, index) {
        final vehicle = Vehicle.available[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 166,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      vehicle.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFFE7EEEA),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.local_shipping_outlined,
                          size: 54,
                          color: Color(0xFF176B5B),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 12,
                      top: 12,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 7,
                          ),
                          child: Text(
                            '${vehicle.capacityTons} ton',
                            style: const TextStyle(
                              color: Color(0xFF176B5B),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text(
                  vehicle.name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  '${vehicle.plateNumber}  •  ${vehicle.description}',
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    onPressed: () => onSelectVehicle(vehicle),
                    icon: const Icon(Icons.arrow_forward, size: 18),
                    label: const Text('Pilih Armada'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
