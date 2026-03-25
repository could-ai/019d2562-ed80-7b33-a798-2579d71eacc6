import 'package:flutter/material.dart';

void main() {
  runApp(const MalaysiaEVApp());
}

class MalaysiaEVApp extends StatelessWidget {
  const MalaysiaEVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Malaysia EV Comparator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00B4DB), // Electric Blue
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const EVHomeScreen(),
      },
    );
  }
}

// --- MODELS ---

class EVCar {
  final String id;
  final String brand;
  final String model;
  final String priceStr;
  final double priceValue; // in RM
  final int range; // in km
  final String bodyType;
  final String batteryCapacity;
  final String acceleration; // 0-100 km/h
  final bool isPopular;

  EVCar({
    required this.id,
    required this.brand,
    required this.model,
    required this.priceStr,
    required this.priceValue,
    required this.range,
    required this.bodyType,
    required this.batteryCapacity,
    required this.acceleration,
    this.isPopular = false,
  });
}

// --- MOCK DATA ---
// Based on 2024-2025 Malaysia EV Market Data
final List<EVCar> evDatabase = [
  EVCar(
    id: '1',
    brand: 'Proton',
    model: 'e.MAS 7',
    priceStr: 'RM 100,000 (Est)',
    priceValue: 100000,
    range: 400,
    bodyType: 'SUV',
    batteryCapacity: '60.2 kWh',
    acceleration: '6.9s',
    isPopular: true,
  ),
  EVCar(
    id: '2',
    brand: 'BYD',
    model: 'Atto 3',
    priceStr: 'RM 105,800',
    priceValue: 105800,
    range: 420,
    bodyType: 'SUV',
    batteryCapacity: '49.9 - 60.4 kWh',
    acceleration: '7.3s',
    isPopular: true,
  ),
  EVCar(
    id: '3',
    brand: 'Tesla',
    model: 'Model 3',
    priceStr: 'RM 189,000',
    priceValue: 189000,
    range: 513,
    bodyType: 'Sedan',
    batteryCapacity: '57.5 - 82 kWh',
    acceleration: '4.4s',
    isPopular: true,
  ),
  EVCar(
    id: '4',
    brand: 'Tesla',
    model: 'Model Y',
    priceStr: 'RM 199,000',
    priceValue: 199000,
    range: 455,
    bodyType: 'SUV',
    batteryCapacity: '57.5 - 82 kWh',
    acceleration: '5.0s',
    isPopular: true,
  ),
  EVCar(
    id: '5',
    brand: 'BYD',
    model: 'Seal',
    priceStr: 'RM 179,800',
    priceValue: 179800,
    range: 570,
    bodyType: 'Sedan',
    batteryCapacity: '82.5 kWh',
    acceleration: '3.8s',
    isPopular: true,
  ),
  EVCar(
    id: '6',
    brand: 'MG',
    model: 'ZS EV',
    priceStr: 'RM 125,999',
    priceValue: 125999,
    range: 320,
    bodyType: 'SUV',
    batteryCapacity: '51.1 kWh',
    acceleration: '8.0s',
  ),
  EVCar(
    id: '7',
    brand: 'Denza',
    model: 'D9',
    priceStr: 'RM 259,000',
    priceValue: 259000,
    range: 600,
    bodyType: 'MPV',
    batteryCapacity: '103.36 kWh',
    acceleration: '6.9s',
  ),
  EVCar(
    id: '8',
    brand: 'Perodua',
    model: 'QV-E',
    priceStr: 'RM 80,000 (Est)',
    priceValue: 80000,
    range: 300,
    bodyType: 'Hatchback',
    batteryCapacity: '40 kWh',
    acceleration: '9.5s',
  ),
  EVCar(
    id: '9',
    brand: 'Neta',
    model: 'V',
    priceStr: 'RM 100,000',
    priceValue: 100000,
    range: 380,
    bodyType: 'SUV',
    batteryCapacity: '38.5 kWh',
    acceleration: '9.0s',
  ),
  EVCar(
    id: '10',
    brand: 'Mercedes-Benz',
    model: 'EQS SUV',
    priceStr: 'RM 699,888',
    priceValue: 699888,
    range: 610,
    bodyType: 'SUV',
    batteryCapacity: '108.4 kWh',
    acceleration: '4.6s',
  ),
];

// --- SCREENS ---

class EVHomeScreen extends StatefulWidget {
  const EVHomeScreen({super.key});

  @override
  State<EVHomeScreen> createState() => _EVHomeScreenState();
}

class _EVHomeScreenState extends State<EVHomeScreen> {
  String _searchQuery = '';
  String _selectedBodyType = 'All';
  final List<String> _bodyTypes = ['All', 'SUV', 'Sedan', 'MPV', 'Hatchback'];
  
  final Set<String> _selectedCarIdsToCompare = {};

  List<EVCar> get filteredCars {
    return evDatabase.where((car) {
      final matchesSearch = car.brand.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                            car.model.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesType = _selectedBodyType == 'All' || car.bodyType == _selectedBodyType;
      return matchesSearch && matchesType;
    }).toList();
  }

  void _toggleCompare(String id) {
    setState(() {
      if (_selectedCarIdsToCompare.contains(id)) {
        _selectedCarIdsToCompare.remove(id);
      } else {
        if (_selectedCarIdsToCompare.length < 3) {
          _selectedCarIdsToCompare.add(id);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You can only compare up to 3 cars at a time.')),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cars = filteredCars;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Malaysia EV Market', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search brand or model (e.g., BYD, Tesla)...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _bodyTypes.map((type) {
                      final isSelected = _selectedBodyType == type;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(type),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedBodyType = type;
                            });
                          },
                          selectedColor: Theme.of(context).colorScheme.primaryContainer,
                          checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          
          // List of Cars
          Expanded(
            child: cars.isEmpty
                ? const Center(child: Text('No EVs found matching your criteria.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(12.0),
                    itemCount: cars.length,
                    itemBuilder: (context, index) {
                      final car = cars[index];
                      final isSelected = _selectedCarIdsToCompare.contains(car.id);
                      
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: isSelected 
                                ? Theme.of(context).colorScheme.primary 
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => _toggleCompare(car.id),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                // Car Icon/Avatar
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.secondaryContainer,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    car.bodyType == 'SUV' ? Icons.directions_suv : 
                                    car.bodyType == 'Sedan' ? Icons.directions_car : 
                                    Icons.airport_shuttle,
                                    size: 40,
                                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                
                                // Car Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${car.brand} ${car.model}',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          if (car.isPopular)
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.orange.shade100,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: const Text(
                                                'Hot',
                                                style: TextStyle(color: Colors.deepOrange, fontSize: 10, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        car.priceStr,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context).colorScheme.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          _buildSpecBadge(context, Icons.battery_charging_full, '${car.range} km'),
                                          const SizedBox(width: 8),
                                          _buildSpecBadge(context, Icons.category, car.bodyType),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Checkbox
                                Checkbox(
                                  value: isSelected,
                                  onChanged: (val) => _toggleCompare(car.id),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: _selectedCarIdsToCompare.length >= 2
          ? FloatingActionButton.extended(
              onPressed: () {
                final selectedCars = evDatabase
                    .where((c) => _selectedCarIdsToCompare.contains(c.id))
                    .toList();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ComparisonScreen(cars: selectedCars),
                  ),
                );
              },
              icon: const Icon(Icons.compare_arrows),
              label: Text('Compare (${_selectedCarIdsToCompare.length})'),
            )
          : null,
    );
  }

  Widget _buildSpecBadge(BuildContext context, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class ComparisonScreen extends StatelessWidget {
  final List<EVCar> cars;

  const ComparisonScreen({super.key, required this.cars});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare EVs'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              dataRowMaxHeight: 80,
              dataRowMinHeight: 60,
              columnSpacing: 40,
              border: TableBorder.all(
                color: Theme.of(context).colorScheme.outlineVariant,
                width: 1,
                borderRadius: BorderRadius.circular(12),
              ),
              columns: [
                const DataColumn(label: Text('Feature', style: TextStyle(fontWeight: FontWeight.bold))),
                ...cars.map((car) => DataColumn(
                      label: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(car.brand, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(car.model, style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    )),
              ],
              rows: [
                _buildRow('Price', cars.map((c) => c.priceStr).toList(), isHighlight: true),
                _buildRow('Body Type', cars.map((c) => c.bodyType).toList()),
                _buildRow('Range (WLTP/NEDC)', cars.map((c) => '${c.range} km').toList(), isHighlight: true),
                _buildRow('Battery Capacity', cars.map((c) => c.batteryCapacity).toList()),
                _buildRow('0-100 km/h', cars.map((c) => c.acceleration).toList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DataRow _buildRow(String feature, List<String> values, {bool isHighlight = false}) {
    return DataRow(
      cells: [
        DataCell(Text(feature, style: const TextStyle(fontWeight: FontWeight.w600))),
        ...values.map((value) => DataCell(
              Text(
                value,
                style: TextStyle(
                  fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
                  color: isHighlight ? Colors.blue.shade700 : null,
                ),
              ),
            )),
      ],
    );
  }
}
