import 'package:flutter/material.dart';
import '../profile_page.dart';  // Import the updated ProfilePage
import '../user.dart';          // Import the User model
import '../pets_page.dart';     // Import the new PetsPage
import '../appointments_page.dart'; // Import the new AppointmentsPage
import '../services_page.dart'; // Import the ServicesPage

class HomePage extends StatefulWidget {
  final User user;

  HomePage({required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late User user;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    _pages = [
      OverviewPage(),
      PetsPage(),
      AppointmentsPage(),
      ServicesPage(),
      ProfilePage(user: user, onUpdate: _updateUser),
    ];
  }

  void _updateUser(User updatedUser) {
    setState(() {
      user = updatedUser;
      _pages[4] = ProfilePage(user: user, onUpdate: _updateUser);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF405D72),
        selectedItemColor: Color(0xFF405D72),
        unselectedItemColor: const Color.fromARGB(255, 122, 186, 180),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Pets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Overview Page
class OverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Overview',
              style: TextStyle(
                fontSize: screenWidth * 0.08,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Quick Links and Featured Content will be displayed here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                color: Colors.teal[700],
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Action for button (e.g., navigate to a feature)
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
              ),
              child: Text(
                'Get Started',
                style: TextStyle(fontSize: screenWidth * 0.05),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
