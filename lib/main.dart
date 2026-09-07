// ============================================================================
// File: lib/main.dart
// Description: Complete Single-File Flutter Roadside Bike Mechanic Booking App
// Compatible with: Flutter 3.x / Dart 3.x (Null-Safe)
// Dependencies: Uses pure Flutter SDK (No external packages required to run!)
// ============================================================================

import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const RoadsideMechanicApp());
}

/// Root Application Widget
class RoadsideMechanicApp extends StatelessWidget {
  const RoadsideMechanicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BikeSathi24 - Roadside Mechanic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE65100), // Amber / Emergency Orange
          primary: const Color(0xFFE65100),
          secondary: const Color(0xFF263238),
          surface: Colors.white,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E293B),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: CardTheme(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white,
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

// ============================================================================
// DATA MODELS
// ============================================================================

enum ProblemCategory {
  flatTyre,
  engineTrouble,
  batteryDead,
  chainBroken,
  brakeIssue,
  outOfFuel,
  electrical,
  generalCheck,
}

class ProblemItem {
  final ProblemCategory category;
  final String title;
  final String description;
  final IconData icon;
  final double estimatedCost;
  final int estimatedTimeMinutes;
  final String? badge;

  const ProblemItem({
    required this.category,
    required this.title,
    required this.description,
    required this.icon,
    required this.estimatedCost,
    required this.estimatedTimeMinutes,
    this.badge,
  });
}

class MechanicProfile {
  final String name;
  final String phone;
  final double rating;
  final int totalRescues;
  final String vehicleModel;
  final String vehiclePlate;
  final String avatarUrl;

  const MechanicProfile({
    required this.name,
    required this.phone,
    required this.rating,
    required this.totalRescues,
    required this.vehicleModel,
    required this.vehiclePlate,
    required this.avatarUrl,
  });
}

// ============================================================================
// MAIN NAVIGATION WRAPPER (State controller for Booking <-> Tracking)
// ============================================================================

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  bool _isTracking = false;
  ProblemItem? _bookedProblem;
  String _selectedBike = 'Royal Enfield Classic 350';
  bool _isEmergency = false;

  final MechanicProfile _assignedMechanic = const MechanicProfile(
    name: 'Rajesh Sharma',
    phone: '+91 98765 43210',
    rating: 4.9,
    totalRescues: 384,
    vehicleModel: 'Hero Splendor (Toolbox Van)',
    vehiclePlate: 'DL 04 AB 8821',
    avatarUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150',
  );

  void _onBookMechanic(ProblemItem problem, String bike, bool emergency) {
    setState(() {
      _bookedProblem = problem;
      _selectedBike = bike;
      _isEmergency = emergency;
      _isTracking = true;
    });
  }

  void _onCancelBooking() {
    setState(() {
      _isTracking = false;
      _bookedProblem = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isTracking && _bookedProblem != null) {
      return MechanicTrackingScreen(
        problem: _bookedProblem!,
        bikeModel: _selectedBike,
        isEmergency: _isEmergency,
        mechanic: _assignedMechanic,
        onCancel: _onCancelBooking,
      );
    }

    return CustomerBookingScreen(
      onBook: _onBookMechanic,
    );
  }
}

// ============================================================================
// SCREEN 1: CUSTOMER BOOKING SCREEN (Problem Selection)
// ============================================================================

class CustomerBookingScreen extends StatefulWidget {
  final Function(ProblemItem problem, String bike, bool emergency) onBook;

  const CustomerBookingScreen({super.key, required this.onBook});

  @override
  State<CustomerBookingScreen> createState() => _CustomerBookingScreenState();
}

class _CustomerBookingScreenState extends State<CustomerBookingScreen> {
  final List<ProblemItem> _problems = const [
    ProblemItem(
      category: ProblemCategory.flatTyre,
      title: 'Flat Tyre / Puncture',
      description: 'Puncture repair or inner tube replacement',
      icon: Icons.tire_repair,
      estimatedCost: 14.00,
      estimatedTimeMinutes: 15,
      badge: 'Most Common',
    ),
    ProblemItem(
      category: ProblemCategory.engineTrouble,
      title: 'Engine Trouble',
      description: 'Engine won\'t start, stalling or smoke',
      icon: Icons.settings,
      estimatedCost: 28.00,
      estimatedTimeMinutes: 35,
      badge: 'Critical',
    ),
    ProblemItem(
      category: ProblemCategory.batteryDead,
      title: 'Dead Battery',
      description: 'Jumpstart or battery check / alternator',
      icon: Icons.battery_alert,
      estimatedCost: 16.00,
      estimatedTimeMinutes: 15,
    ),
    ProblemItem(
      category: ProblemCategory.chainBroken,
      title: 'Broken / Slipped Chain',
      description: 'Chain link fix, tension adjustment, lube',
      icon: Icons.link,
      estimatedCost: 19.00,
      estimatedTimeMinutes: 20,
    ),
    ProblemItem(
      category: ProblemCategory.brakeIssue,
      title: 'Brake Failure / Jam',
      description: 'Brake pad jammed, fluid leak, wire cut',
      icon: Icons.do_not_disturb_on,
      estimatedCost: 24.00,
      estimatedTimeMinutes: 25,
      badge: 'Urgent',
    ),
    ProblemItem(
      category: ProblemCategory.outOfFuel,
      title: 'Out of Petrol / Fuel',
      description: '2-3 Litres emergency fuel delivery to spot',
      icon: Icons.local_gas_station,
      estimatedCost: 10.00,
      estimatedTimeMinutes: 15,
    ),
    ProblemItem(
      category: ProblemCategory.electrical,
      title: 'Electrical / Spark Plug',
      description: 'Headlight off, spark plug fouling, fuse blown',
      icon: Icons.bolt,
      estimatedCost: 18.00,
      estimatedTimeMinutes: 20,
    ),
    ProblemItem(
      category: ProblemCategory.generalCheck,
      title: 'Other Breakdown',
      description: 'Accident tow assessment or unknown noise',
      icon: Icons.build_circle,
      estimatedCost: 20.00,
      estimatedTimeMinutes: 30,
    ),
  ];

  late ProblemItem _selectedProblem;
  String _selectedBike = 'Royal Enfield Classic 350';
  bool _isEmergency = false;
  final String _currentAddress = 'Outer Ring Road, Near Flyover Pillar 142';

  final List<String> _myBikes = [
    'Royal Enfield Classic 350',
    'Yamaha MT-15',
    'Honda Activa 6G',
    'KTM Duke 250',
  ];

  @override
  void initState() {
    super.initState();
    _selectedProblem = _problems.first;
  }

  void _confirmAndRequest() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(_selectedProblem.icon, color: const Color(0xFFE65100), size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedProblem.title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _selectedBike,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),
            _summaryRow('Callout & Diagnosis', '\$5.00'),
            _summaryRow('Estimated Fix Cost', '\$${_selectedProblem.estimatedCost.toStringAsFixed(2)}'),
            if (_isEmergency)
              _summaryRow('Emergency Priority', '\$6.00', isHighlight: true),
            const Divider(height: 24),
            _summaryRow(
              'Total Estimate',
              '\$${(_selectedProblem.estimatedCost + 5.0 + (_isEmergency ? 6.0 : 0.0)).toStringAsFixed(2)}',
              isBold: true,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE65100),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  widget.onBook(_selectedProblem, _selectedBike, _isEmergency);
                },
                child: const Text(
                  'Confirm & Dispatch Mechanic',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false, bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.w600, color: isHighlight ? const Color(0xFFE65100) : Colors.black)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BikeSathi24 - Breakdown Assistance'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    const Icon(Icons.my_location, color: Colors.blue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('YOUR LOCATION', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                          Text(_currentAddress, style: const TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Select Your Bike', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _myBikes.map((bike) {
                  final isSelected = _selectedBike == bike;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(bike),
                      selected: isSelected,
                      selectedColor: const Color(0xFF1E293B),
                      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                      onSelected: (_) => setState(() => _selectedBike = bike),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            const Text('What\'s the Problem?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _problems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.25,
              ),
              itemBuilder: (context, index) {
                final item = _problems[index];
                final isSelected = _selectedProblem.category == item.category;
                return InkWell(
                  onTap: () => setState(() => _selectedProblem = item),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFFF3E0) : Colors.white,
                      border: Border.all(color: isSelected ? const Color(0xFFE65100) : Colors.grey.shade300, width: isSelected ? 2 : 1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item.icon, color: const Color(0xFFE65100)),
                        const SizedBox(height: 8),
                        Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Text('\$${item.estimatedCost.toStringAsFixed(0)} • ${item.estimatedTimeMinutes}m', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE65100), foregroundColor: Colors.white),
                onPressed: _confirmAndRequest,
                child: const Text('Proceed to Request', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// SCREEN 2: MECHANIC TRACKING SCREEN
// ============================================================================

class MechanicTrackingScreen extends StatelessWidget {
  final ProblemItem problem;
  final String bikeModel;
  final bool isEmergency;
  final MechanicProfile mechanic;
  final VoidCallback onCancel;

  const MechanicTrackingScreen({
    super.key,
    required this.problem,
    required this.bikeModel,
    required this.isEmergency,
    required this.mechanic,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mechanic On The Way'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.redAccent),
            onPressed: onCancel,
            tooltip: 'Cancel Booking',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
              ),
              child: Column(
                children: [
                  const LinearProgressIndicator(color: Color(0xFFE65100)),
                  const SizedBox(height: 16),
                  const Text('Mechanic is heading to your location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Estimated Arrival: ~7 Mins', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(radius: 30, backgroundColor: Colors.orange[100], child: const Icon(Icons.person, size: 35, color: Color(0xFFE65100))),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(mechanic.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('Rating: ⭐ ${mechanic.rating} (${mechanic.totalRescues} rescues)', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          Text(mechanic.vehicleModel, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.phone, color: Colors.green, size: 30),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                style: OutlinedButton.styl
