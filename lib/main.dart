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
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DriverMainScreen()));
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

// ================= BOTTOM NAVIGATION CONTROLLER =================
class DriverMainScreen extends StatefulWidget {
  const DriverMainScreen({super.key});
  @override
  State<DriverMainScreen> createState() => _DriverMainScreenState();
}

class _DriverMainScreenState extends State<DriverMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const DriverDashboardTab(),
    const DriverTripsTab(),
    const DriverEarningsTab(),
    const DriverProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Trips'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Earnings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// ================= D-05 & D-06: DASHBOARD TAB =================
class DriverDashboardTab extends StatefulWidget {
  const DriverDashboardTab({super.key});
  @override
  State<DriverDashboardTab> createState() => _DriverDashboardTabState();
}

class _DriverDashboardTabState extends State<DriverDashboardTab> {
  bool _isOnline = false;

  void _toggleStatus(bool value) {
    setState(() => _isOnline = value);
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
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DriverLoginScreen())),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
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
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _isOnline ? Colors.green : Colors.grey[700]),
                      ),
                      const SizedBox(height: 5),
                      Text(_isOnline ? 'Waiting for requests...' : 'Go online to get rides', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                  Switch(value: _isOnline, onChanged: _toggleStatus, activeColor: Colors.green),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildStatCard('Today\'s Earnings', '₹0', Icons.currency_rupee, Colors.blue)),
                const SizedBox(width: 15),
                Expanded(child: _buildStatCard('Today\'s Trips', '0', Icons.local_shipping, Colors.orange)),
              ],
            ),
            const Spacer(),
            if (_isOnline)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RideRequestScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 60),
                ),
                child: const Text('Simulate: New Ride Request Aayegi', style: TextStyle(fontSize: 16, color: Colors.white)),
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
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

// ================= D-07: RIDE REQUEST SCREEN =================
class RideRequestScreen extends StatelessWidget {
  const RideRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('New Ride Request!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
              const Divider(height: 30),
              _buildLocRow(Icons.my_location, Colors.green, 'Pickup', 'Mahalaxmi Enclave, Delhi'),
              const SizedBox(height: 15),
              _buildLocRow(Icons.location_on, Colors.red, 'Drop', 'Timarpur, Delhi'),
              const Divider(height: 30),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Distance: 5 km', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Fare: ₹372', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green)),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(minimumSize: const Size(0, 50)),
                      child: const Text('Reject', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ActiveTripScreen()));
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(0, 50)),
                      child: const Text('Accept', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocRow(IconData icon, Color color, String title, String address) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text(address, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}

// ================= D-08, D-09, D-10: ACTIVE TRIP SCREEN =================
class ActiveTripScreen extends StatefulWidget {
  const ActiveTripScreen({super.key});
  @override
  State<ActiveTripScreen> createState() => _ActiveTripScreenState();
}

class _ActiveTripScreenState extends State<ActiveTripScreen> {
  int _tripStatus = 0; // 0: Going to Pickup, 1: At Pickup, 2: In Transit, 3: Delivered
  final TextEditingController _otpController = TextEditingController();

  void _updateStatus() {
    if (_tripStatus < 3) {
      setState(() => _tripStatus++);
    }
  }

  void _completeDelivery() {
    if (_otpController.text == '1234') {
      Navigator.popUntil(context, (route) => route.isFirst);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Delivery Successful! ₹372 added to wallet.'), backgroundColor: Colors.green));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Galat OTP! Customer se poocho (Testing: 1234)'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Active Trip'), backgroundColor: Colors.green, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(15)),
              child: const Center(child: Text('Map Navigation Yahan Aayega', style: TextStyle(color: Colors.grey))),
            ),
            const SizedBox(height: 30),
            Text(
              _tripStatus == 0 ? 'Pickup ki taraf ja rahe hain...' :
              _tripStatus == 1 ? 'Customer ke paas pahunch gaye hain' :
              _tripStatus == 2 ? 'Delivery ki taraf ja rahe hain...' : 'Delivery Point par hain',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            if (_tripStatus < 3)
              ElevatedButton(
                onPressed: _updateStatus,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(double.infinity, 60)),
                child: Text(
                  _tripStatus == 0 ? 'Arrived at Pickup' :
                  _tripStatus == 1 ? 'Goods Picked Up' : 'Arrived at Drop',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            if (_tripStatus == 3) ...[
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Enter Customer OTP (Test: 1234)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: _completeDelivery,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, minimumSize: const Size(double.infinity, 60)),
                child: const Text('Complete Delivery', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

// ================= DUMMY TABS =================
class DriverTripsTab extends StatelessWidget {
  const DriverTripsTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Trips'), backgroundColor: Colors.green, foregroundColor: Colors.white),
      body: const Center(child: Text('Abhi tak koi trip complete nahi ki.')),
    );
  }
}

class DriverEarningsTab extends StatelessWidget {
  const DriverEarningsTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Earnings'), backgroundColor: Colors.green, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(15)),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Wallet Balance', style: TextStyle(color: Colors.white, fontSize: 16)),
                  Text('₹0', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DriverProfileTab extends StatelessWidget {
  const DriverProfileTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Driver Profile'), backgroundColor: Colors.green, foregroundColor: Colors.white),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          const Center(
            child: Column(
              children: [
                CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
                SizedBox(height: 10),
                Text('Ramesh Kumar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('Tata Ace - UP 32 AB 1234', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          ListTile(leading: const Icon(Icons.badge, color: Colors.green), title: const Text('My Documents'), trailing: const Icon(Icons.arrow_forward_ios), onTap: (){}),
          ListTile(leading: const Icon(Icons.support_agent, color: Colors.green), title: const Text('Help & Support'), trailing: const Icon(Icons.arrow_forward_ios), onTap: (){}),
          ListTile(leading: const Icon(Icons.settings, color: Colors.green), title: const Text('Settings'), trailing: const Icon(Icons.arrow_forward_ios), onTap: (){}),
        ],
      ),
    );
  }
}
