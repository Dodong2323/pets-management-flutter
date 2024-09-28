import 'package:flutter/material.dart';
import 'user.dart'; // Import the User model
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  final User user;
  final Function(User) onUpdate;

  ProfilePage({required this.user, required this.onUpdate});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;
  late TextEditingController firstNameController;
  late TextEditingController middleNameController;
  late TextEditingController lastNameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.user.firstName);
    middleNameController = TextEditingController(text: widget.user.middleName);
    lastNameController = TextEditingController(text: widget.user.lastName);
    usernameController = TextEditingController(text: widget.user.username);
    emailController = TextEditingController(text: widget.user.email);
    phoneController = TextEditingController(text: widget.user.phone);
    addressController = TextEditingController(text: widget.user.address);
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    if (firstNameController.text.isEmpty ||
        middleNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty) {
      _showAlertDialog('Error', 'Please fill in all fields.');
      return;
    }

    var url = Uri.parse('http://localhost/pet_management/api/flutter_login_register.php?action=update');
    try {
      var response = await http.post(url,
          body: jsonEncode({
            'id': widget.user.id,
            'username': usernameController.text,
            'password': passwordController.text.isEmpty ? widget.user.password : passwordController.text,
            'first_name': firstNameController.text,
            'middle_name': middleNameController.text,
            'last_name': lastNameController.text,
            'email': emailController.text,
            'phone': phoneController.text,
            'address': addressController.text,
          }),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['error'] != null) {
          _showAlertDialog('Error', data['error'], isError: true);
        } else {
          User updatedUser = User(
            id: widget.user.id,
            firstName: firstNameController.text,
            middleName: middleNameController.text,
            lastName: lastNameController.text,
            username: usernameController.text,
            password: passwordController.text.isEmpty ? widget.user.password : passwordController.text,
            email: emailController.text,
            phone: phoneController.text,
            address: addressController.text,
            profilePicture: widget.user.profilePicture,
            createdAt: widget.user.createdAt,
          );
          widget.onUpdate(updatedUser);
          _showAlertDialog('Success', 'Profile updated successfully.');
          setState(() {
            isEditing = false;
            passwordController.clear();
          });
        }
      } else {
        _showAlertDialog('Error', 'Network error. Please try again.', isError: true);
      }
    } catch (e) {
      _showAlertDialog('Error', 'Failed to connect to the server.', isError: true);
    }
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
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: widget.user.profilePicture.isNotEmpty
                      ? NetworkImage(widget.user.profilePicture)
                      : null,
                  child: widget.user.profilePicture.isEmpty
                      ? Icon(Icons.person, size: 50, color: Colors.teal)
                      : null,
                ),
                SizedBox(height: 20),
                isEditing ? _buildEditableFields() : _buildProfileDetails(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (isEditing) {
                      _saveChanges();
                    } else {
                      setState(() {
                        isEditing = true;
                      });
                    }
                  },
                  child: Text(isEditing ? 'Save Changes' : 'Edit Profile'),
                  style: ElevatedButton.styleFrom(
                    // primary: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(widget.user.firstName),
        SizedBox(height: 10),
        _buildDetailRow(widget.user.middleName),
        SizedBox(height: 10),
        _buildDetailRow(widget.user.lastName),
        SizedBox(height: 10),
        _buildDetailRow(widget.user.username),
        SizedBox(height: 10),
        _buildDetailRow(widget.user.email),
        SizedBox(height: 10),
        _buildDetailRow(widget.user.phone),
        SizedBox(height: 10),
        _buildDetailRow(widget.user.address),
      ],
    );
  }

  Widget _buildDetailRow(String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(value, style: TextStyle(fontSize: 16))),
      ],
    );
  }

  Widget _buildEditableFields() {
    return Column(
      children: [
        _buildEditableField(firstNameController),
        SizedBox(height: 10),
        _buildEditableField(middleNameController),
        SizedBox(height: 10),
        _buildEditableField(lastNameController),
        SizedBox(height: 10),
        _buildEditableField(usernameController),
        SizedBox(height: 10),
        _buildEditableField(emailController),
        SizedBox(height: 10),
        _buildEditableField(phoneController),
        SizedBox(height: 10),
        _buildEditableField(addressController),
        SizedBox(height: 10),
        _buildEditablePasswordField(),
      ],
    );
  }

  Widget _buildEditableField(TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildEditablePasswordField() {
    return TextField(
      controller: passwordController,
      decoration: InputDecoration(
        hintText: 'Leave blank to keep current password',
        border: OutlineInputBorder(),
      ),
      obscureText: true,
    );
  }
}
