import 'package:aplikasi_flutter_pertamaku/main.dart';
import 'package:aplikasi_flutter_pertamaku/screens/cargo_booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> signIn(WidgetTester tester) async {
    await tester.pumpWidget(const CargoFlowApp());
    await tester.enterText(find.byType(TextField).at(0), 'petugas');
    await tester.enterText(find.byType(TextField).at(1), '1234');
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();
  }

  testWidgets('staf dapat masuk dan melihat navigasi utama', (tester) async {
    await signIn(tester);

    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Armada Tersedia'), findsOneWidget);
  });

  testWidgets('booking menerbitkan dan mengembalikan data resi', (
    tester,
  ) async {
    await signIn(tester);

    await tester.tap(find.text('Pilih Armada').first);
    await tester.pumpAndSettle();

    expect(find.byType(RadioGroup<String>), findsOneWidget);
    expect(find.byType(RadioListTile<String>), findsNWidgets(3));
    expect(find.byType(CheckboxGroup), findsOneWidget);
    expect(find.byType(CheckboxListTile), findsNWidgets(3));

    await tester.scrollUntilVisible(
      find.text('Hitung Biaya Logistik'),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Hitung Biaya Logistik'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Terbitkan Surat Jalan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ya, terbitkan'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Berhasil diterbitkan: CF-'), findsOneWidget);
  });
}
