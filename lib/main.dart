import 'package:flutter/material.dart';

void main() {
  runApp(const ToudiDriverApp());
}

class ToudiDriverApp extends StatelessWidget {
  const ToudiDriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toudi Driver',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      home: const DriverLoginScreen(),
    );
  }
}

// ================= D-01: DRIVER LOGIN SCREEN =================
class DriverLoginScreen extends StatefulWidget {
  const DriverLoginScreen({super.key});
  @override
  State<DriverLoginScreen> createState() => _DriverLoginScreenState();
}

class _DriverLoginScreenState extends State<DriverLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  void _login() {
    if (_phoneController.text.length == 10) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DriverHomeScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('10 digit ka mobile number daalo!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.local_shipping, size: 100, color: Colors.green),
              const SizedBox(height: 20),
              const Text('Toudi Driver Partner', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green)),
              const SizedBox(height: 10),
              const Text('Start earning with your vehicle'),
              const SizedBox(height: 40),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Login / Register', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= D-05 & D-06: DRIVER HOME SCREEN =================
class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});
  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  bool _isOnline = false;

  void _toggleStatus(bool value) {
    setState(() {
      _isOnline = value;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isOnline ? 'Aap Online ho gaye hain!' : 'Aap Offline ho gaye hain.'),
        backgroundColor: _isOnline ? Colors.green : Colors.red,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Dashboard'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DriverLoginScreen()));
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Online/Offline Toggle Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _isOnline ? Colors.green[50] : Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: _isOnline ? Colors.green : Colors.grey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isOnline ? 'You are Online' : 'You are Offline',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _isOnline ? Colors.green : Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _isOnline ? 'Waiting for ride requests...' : 'Go online to get rides',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  Switch(
                    value: _isOnline,
                    onChanged: _toggleStatus,
                    activeColor: Colors.green,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Earnings & Trips Summary
            Row(
              children: [
                Expanded(
                  child: _buildStatCard('Today\'s Earnings', '₹0', Icons.currency_rupee, Colors.blue),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildStatCard('Today\'s Trips', '0', Icons.local_shipping, Colors.orange),
                ),
              ],
            ),

            const Spacer(),
            
            if (!_isOnline)
              const Text(
                'Gaadi chalu karne ke liye Online ho jayein.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            if (_isOnline)
              const Text(
                'Ride request ka intezaar hai...',
                style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: color),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
