import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica_02_dart_estado/main.dart';

void main() {
  testWidgets('La app carga correctamente', (WidgetTester tester) async {
    // Configurar tamaño de pantalla más grande
    tester.view.physicalSize = const Size(1200, 2000);
    tester.view.devicePixelRatio = 1.0;

    // Restablecer después del test
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Cargar la app
    await tester.pumpWidget(const App());

    // Verificar que el menú aparece
    expect(find.text('Práctica 02 - Menú'), findsOneWidget);
  });
}