import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home/HomePage.dart'; // Import the HomePage
import 'user.dart'; // Import the User model

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login and Registration',
      theme: ThemeData(
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
            textStyle: TextStyle(fontSize: 16),
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.teal[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        ),
      ),
      home: AuthPage(),
    );
  }
}

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  int currentStep = 0;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  void login() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      _showAlertDialog('Error', 'Please fill in all fields.');
      return;
    }

    var url = Uri.parse('http://localhost/pet_management/api/flutter_login_register.php?action=login');
    try {
      var response = await http.post(url, body: jsonEncode({
        'username': usernameController.text,
        'password': passwordController.text,
      }), headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['error'] != null) {
          _showAlertDialog('Error', data['error'], isError: true);
        } else {
          User user = User.fromJson(data['user']);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage(user: user)),
          );
        }
      } else {
        _showAlertDialog('Error', 'Network error. Please try again.', isError: true);
      }
    } catch (e) {
      _showAlertDialog('Error', 'Failed to connect to the server.', isError: true);
    }
  }

  void register() async {
    if (firstNameController.text.isEmpty || middleNameController.text.isEmpty ||
        lastNameController.text.isEmpty || emailController.text.isEmpty ||
        phoneController.text.isEmpty || addressController.text.isEmpty ||
        usernameController.text.isEmpty || passwordController.text.isEmpty) {
      _showAlertDialog('Error', 'Please fill in all fields.');
      return;
    }

    var url = Uri.parse('http://localhost/pet_management/api/flutter_login_register.php?action=register');
    try {
      var response = await http.post(url, body: jsonEncode({
        'username': usernameController.text,
        'password': passwordController.text,
        'first_name': firstNameController.text,
        'middle_name': middleNameController.text,
        'last_name': lastNameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'address': addressController.text,
      }), headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['error'] != null) {
          _showAlertDialog('Error', data['error'], isError: true);
        } else {
          _showAlertDialog('Success', data['message']);
          setState(() {
            isLogin = true;
            currentStep = 0;
            _clearControllers();
          });
        }
      } else {
        _showAlertDialog('Error', 'Network error. Please try again.', isError: true);
      }
    } catch (e) {
      _showAlertDialog('Error', 'Failed to connect to the server.', isError: true);
    }
  }

  void _clearControllers() {
    usernameController.clear();
    passwordController.clear();
    firstNameController.clear();
    middleNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneController.clear();
    addressController.clear();
  }

  void _showAlertDialog(String title, String message, {bool isError = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: TextStyle(color: isError ? Colors.red : Colors.green)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK', style: TextStyle(color: Theme.of(context).primaryColor)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = EdgeInsets.symmetric(horizontal: screenWidth * 0.05);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: padding,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.teal[100],
                  child: Icon(Icons.person, size: 50, color: Colors.teal),
                ),
                SizedBox(height: 40),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: isLogin ? _buildLoginCard() : _buildRegistrationCard(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginCard() {
    return Card(
      key: ValueKey<bool>(isLogin),
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildTextField(usernameController, 'Username'),
            SizedBox(height: 20),
            _buildTextField(passwordController, 'Password', obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: Text('LOGIN'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = false;
                  currentStep = 0;
                });//add user level
              },
              child: Text('Create an account', style: TextStyle(color: Theme.of(context).primaryColor)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrationCard() {
    return Card(
      key: ValueKey<int>(currentStep),
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            if (currentStep == 0) ...[
              _buildTextField(firstNameController, 'First Name'),
              SizedBox(height: 20),
              _buildTextField(middleNameController, 'Middle Name'),
              SizedBox(height: 20),
              _buildTextField(lastNameController, 'Last Name'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (firstNameController.text.isEmpty || middleNameController.text.isEmpty || lastNameController.text.isEmpty) {
                    _showAlertDialog('Error', 'Please fill in all fields.');
                  } else {
                    setState(() {
                      currentStep = 1;
                    });
                  }
                },
                child: Text('Next'),
              ),
            ] else if (currentStep == 1) ...[
              _buildTextField(emailController, 'Email'),
              SizedBox(height: 20),
              _buildTextField(phoneController, 'Phone Number'),
              SizedBox(height: 20),
              _buildTextField(addressController, 'Address'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (emailController.text.isEmpty || phoneController.text.isEmpty || addressController.text.isEmpty) {
                    _showAlertDialog('Error', 'Please fill in all fields.');
                  } else {
                    setState(() {
                      currentStep = 2;
                    });
                  }
                },
                child: Text('Next'),
              ),
            ] else if (currentStep == 2) ...[
              _buildTextField(usernameController, 'Username'),
              SizedBox(height: 20),
              _buildTextField(passwordController, 'Password', obscureText: true),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: register,
                child: Text('Register'),
              ),
            ],
            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = true;
                  currentStep = 0;
                });
              },
              child: Text('Already have an account? Log in', style: TextStyle(color: Theme.of(context).primaryColor)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
      ),
    );
  }
}
