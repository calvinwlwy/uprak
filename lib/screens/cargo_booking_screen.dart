import 'package:flutter/material.dart';

import '../models/booking_result.dart';
import '../models/vehicle.dart';

class CargoBookingScreen extends StatefulWidget {
  const CargoBookingScreen({required this.vehicle, super.key});

  final Vehicle vehicle;

  @override
  State<CargoBookingScreen> createState() => _CargoBookingScreenState();
}

class _CargoBookingScreenState extends State<CargoBookingScreen> {
  static const _cargoTypes = [
    'General Cargo',
    'Makanan Beku/Perishable',
    'Alat Berat',
  ];
  static const _protectionOptions = [
    ('Asuransi Barang Rusak', 150000),
    ('Jasa Forklift Muat', 200000),
    ('Pengawalan Prioritas', 350000),
  ];

  String _cargoType = _cargoTypes.first;
  final Set<String> _selectedProtections = {};
  DateTime? _pickupDate;
  TimeOfDay? _departureTime;
  late double _tonnage = widget.vehicle.capacityTons.toDouble().clamp(1, 3);
  bool _reeferEnabled = false;

  int get _totalCost {
    final protectionCost = _protectionOptions
        .where((option) => _selectedProtections.contains(option.$1))
        .fold<int>(0, (total, option) => total + option.$2);
    final reeferCost = _reeferEnabled ? 250000 : 0;
    return 250000 + (_tonnage * 75000).round() + protectionCost + reeferCost;
  }

  String _formatCurrency(int amount) {
    final digits = amount.toString();
    final buffer = StringBuffer('Rp ');
    for (var index = 0; index < digits.length; index++) {
      buffer.write(digits[index]);
      final remaining = digits.length - index - 1;
      if (remaining > 0 && remaining % 3 == 0) buffer.write('.');
    }
    return buffer.toString();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: _pickupDate ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 1),
      helpText: 'Pilih tanggal penjemputan',
    );
    if (selected != null && mounted) setState(() => _pickupDate = selected);
  }

  Future<void> _pickTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: _departureTime ?? const TimeOfDay(hour: 8, minute: 0),
      helpText: 'Pilih estimasi keberangkatan',
    );
    if (selected != null && mounted) setState(() => _departureTime = selected);
  }

  String _dateLabel() {
    final date = _pickupDate;
    if (date == null) return 'Pilih tanggal';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  Future<void> _showCostBreakdown() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Rincian biaya logistik',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              _CostRow(label: 'Biaya dasar armada', amount: 250000),
              _CostRow(
                label: 'Tonase ${_tonnage.toStringAsFixed(1)} ton',
                amount: (_tonnage * 75000).round(),
              ),
              for (final option in _protectionOptions)
                if (_selectedProtections.contains(option.$1))
                  _CostRow(label: option.$1, amount: option.$2),
              if (_reeferEnabled)
                const _CostRow(
                  label: 'Layanan reefer container',
                  amount: 250000,
                ),
              const Divider(height: 28),
              _CostRow(
                label: 'Total estimasi',
                amount: _totalCost,
                isTotal: true,
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 50,
                child: FilledButton.icon(
                  onPressed: () => _confirmWaybill(sheetContext),
                  icon: const Icon(Icons.receipt_long),
                  label: const Text('Terbitkan Surat Jalan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmWaybill(BuildContext sheetContext) async {
    final approved = await showDialog<bool>(
      context: sheetContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Terbitkan surat jalan?'),
        content: Text(
          'Surat jalan untuk ${widget.vehicle.name} akan diterbitkan dengan '
          'estimasi biaya ${_formatCurrency(_totalCost)}.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Periksa kembali'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Ya, terbitkan'),
          ),
        ],
      ),
    );

    if (approved != true || !mounted || !sheetContext.mounted) return;
    final result = BookingResult(
      receiptNumber: 'CF-${DateTime.now().millisecondsSinceEpoch}',
      status: 'Berhasil diterbitkan',
    );
    Navigator.of(sheetContext).pop();
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final minimumTonnage = 1.0;
    final maximumTonnage = widget.vehicle.capacityTons.toDouble();

    return Scaffold(
      appBar: AppBar(title: const Text('Booking Kargo')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
        children: [
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE5F0EB),
                child: Icon(Icons.local_shipping, color: Color(0xFF176B5B)),
              ),
              title: Text(
                widget.vehicle.name,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                '${widget.vehicle.plateNumber}  •  Kapasitas ${widget.vehicle.capacityTons} ton',
              ),
            ),
          ),
          const SizedBox(height: 18),
          const _SectionHeading(title: 'Kategori Muatan'),
          const SizedBox(height: 8),
          Card(
            child: RadioGroup<String>(
              groupValue: _cargoType,
              onChanged: (value) {
                if (value != null) setState(() => _cargoType = value);
              },
              child: Column(
                children: [
                  for (final cargoType in _cargoTypes)
                    RadioListTile<String>(
                      value: cargoType,
                      title: Text(cargoType),
                      selected: _cargoType == cargoType,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const _SectionHeading(title: 'Proteksi Pengiriman'),
          const SizedBox(height: 4),
          CheckboxGroup(
            options: _protectionOptions,
            selectedValues: _selectedProtections,
            formatAmount: _formatCurrency,
            onChanged: (label, selected) => setState(() {
              if (selected) {
                _selectedProtections.add(label);
              } else {
                _selectedProtections.remove(label);
              }
            }),
          ),
          const SizedBox(height: 20),
          const _SectionHeading(title: 'Jadwal Pengambilan'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_month_outlined),
                  label: Text(_dateLabel()),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickTime,
                  icon: const Icon(Icons.schedule),
                  label: Text(_departureTime?.format(context) ?? 'Pilih jam'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const _SectionHeading(title: 'Pengaturan Muatan'),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(child: Text('Estimasi tonase')),
                      Text(
                        '${_tonnage.toStringAsFixed(1)} ton',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF176B5B),
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    min: minimumTonnage,
                    max: maximumTonnage,
                    divisions: maximumTonnage > minimumTonnage
                        ? ((maximumTonnage - minimumTonnage) * 2).round()
                        : null,
                    label: '${_tonnage.toStringAsFixed(1)} ton',
                    value: _tonnage.clamp(minimumTonnage, maximumTonnage),
                    onChanged: maximumTonnage > minimumTonnage
                        ? (value) => setState(() => _tonnage = value)
                        : null,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${minimumTonnage.toStringAsFixed(0)} ton'),
                      Text('${maximumTonnage.toStringAsFixed(0)} ton'),
                    ],
                  ),
                  const Divider(height: 24),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Reefer container'),
                    subtitle: const Text('Aktifkan mesin pendingin kontainer'),
                    value: _reeferEnabled,
                    onChanged: (value) =>
                        setState(() => _reeferEnabled = value),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: _showCostBreakdown,
              icon: const Icon(Icons.calculate_outlined),
              label: const Text('Hitung Biaya Logistik'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium
          ?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class CheckboxGroup extends StatelessWidget {
  const CheckboxGroup({
    required this.options,
    required this.selectedValues,
    required this.formatAmount,
    required this.onChanged,
    super.key,
  });

  final List<(String, int)> options;
  final Set<String> selectedValues;
  final String Function(int) formatAmount;
  final void Function(String, bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: 'Pilihan proteksi pengiriman',
      child: Card(
        child: Column(
          children: [
            for (var index = 0; index < options.length; index++) ...[
              if (index > 0) const Divider(height: 1, indent: 16),
              CheckboxListTile(
                value: selectedValues.contains(options[index].$1),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                title: Text(options[index].$1),
                subtitle: Text('+ ${formatAmount(options[index].$2)}'),
                onChanged: (selected) =>
                    onChanged(options[index].$1, selected ?? false),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CostRow extends StatelessWidget {
  const _CostRow({
    required this.label,
    required this.amount,
    this.isTotal = false,
  });

  final String label;
  final int amount;
  final bool isTotal;

  String _formatCurrency(int value) {
    final digits = value.toString();
    final buffer = StringBuffer('Rp ');
    for (var index = 0; index < digits.length; index++) {
      buffer.write(digits[index]);
      final remaining = digits.length - index - 1;
      if (remaining > 0 && remaining % 3 == 0) buffer.write('.');
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isTotal ? FontWeight.w700 : FontWeight.normal,
              ),
            ),
          ),
          Text(
            _formatCurrency(amount),
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: isTotal ? const Color(0xFF176B5B) : null,
            ),
          ),
        ],
      ),
    );
  }
}
