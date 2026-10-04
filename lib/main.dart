import 'package:flutter/material.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true),
    home: const MenuPage(),
  );
}

// ============================================
// MENÚ PRINCIPAL
// ============================================
class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Práctica 02 - Menú'), centerTitle: true),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FilledButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PropinaPage()),
            ),
            icon: const Icon(Icons.restaurant),
            label: const Text('Calculadora de Propina'),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CombustiblePage()),
            ),
            icon: const Icon(Icons.local_gas_station),
            label: const Text('Consumo de Combustible'),
          ),
        ],
      ),
    ),
  );
}

// ============================================
// EJEMPLO GUIADO: CALCULADORA DE PROPINA
// ============================================
class PropinaPage extends StatefulWidget {
  const PropinaPage({super.key});

  @override
  State<PropinaPage> createState() => _PropinaPageState();
}

class _PropinaPageState extends State<PropinaPage> {
  final consumo = TextEditingController();
  double porcentaje = 10;
  double propina = 0;
  double total = 0;

  void calcular() {
    final valor = double.tryParse(consumo.text) ?? 0;
    setState(() {
      propina = valor * porcentaje / 100;
      total = valor + propina;
    });
  }

  @override
  void dispose() {
    consumo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora de Propina')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: consumo,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Consumo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Text('Propina: ${porcentaje.toInt()} %'),
            Slider(
              value: porcentaje,
              min: 0,
              max: 30,
              divisions: 6,
              onChanged: (v) => setState(() => porcentaje = v),
            ),
            FilledButton(onPressed: calcular, child: const Text('Calcular')),
            const SizedBox(height: 20),
            Text('Propina: \$${propina.toStringAsFixed(2)}'),
            Text('Total: \$${total.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}

// ============================================
// EJERCICIO EVALUABLE: CONSUMO DE COMBUSTIBLE
// ============================================
class CombustiblePage extends StatefulWidget {
  const CombustiblePage({super.key});

  @override
  State<CombustiblePage> createState() => _CombustiblePageState();
}

class _CombustiblePageState extends State<CombustiblePage> {
  final kmController = TextEditingController();
  final litrosController = TextEditingController();
  double rendimiento = 0;
  String clasificacion = '';
  String error = '';

  void calcular() {
    final km = double.tryParse(kmController.text);
    final litros = double.tryParse(litrosController.text);

    // Validación 1: Campos vacíos o no numéricos
    if (km == null || litros == null) {
      setState(() {
        error = '⚠️ Ingresa valores numéricos válidos';
        rendimiento = 0;
        clasificacion = '';
      });
      return;
    }

    // Validación 2: Valores menores o iguales a cero
    if (km <= 0 || litros <= 0) {
      setState(() {
        error = '⚠️ Los valores deben ser mayores a cero';
        rendimiento = 0;
        clasificacion = '';
      });
      return;
    }

    // Cálculo
    final resultado = km / litros;

    // Clasificación en 3 niveles
    String nivel;
    if (resultado >= 15) {
      nivel = '🟢 Excelente rendimiento';
    } else if (resultado >= 10) {
      nivel = '🟡 Rendimiento moderado';
    } else {
      nivel = '🔴 Bajo rendimiento';
    }

    setState(() {
      rendimiento = resultado;
      clasificacion = nivel;
      error = '';
    });
  }

  void limpiar() {
    kmController.clear();
    litrosController.clear();
    setState(() {
      rendimiento = 0;
      clasificacion = '';
      error = '';
    });
  }

  @override
  void dispose() {
    kmController.dispose();
    litrosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consumo de Combustible')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: kmController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Kilómetros recorridos',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.directions_car),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: litrosController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Litros utilizados',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.local_gas_station),
              ),
            ),
            const SizedBox(height: 20),
            if (error.isNotEmpty)
              Text(
                error,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton.icon(
                  onPressed: calcular,
                  icon: const Icon(Icons.calculate),
                  label: const Text('Calcular'),
                ),
                OutlinedButton.icon(
                  onPressed: limpiar,
                  icon: const Icon(Icons.clear),
                  label: const Text('Limpiar'),
                ),
              ],
            ),
            const SizedBox(height: 30),
            if (rendimiento > 0) ...[
              Text(
                'Rendimiento: ${rendimiento.toStringAsFixed(2)} km/L',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(clasificacion, style: const TextStyle(fontSize: 20)),
            ],
          ],
        ),
      ),
    );
  }
}
