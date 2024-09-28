import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PetsPage extends StatefulWidget {
  @override
  _PetsPageState createState() => _PetsPageState();
}

class _PetsPageState extends State<PetsPage> {
  List<Map<String, String>> pets = []; // List to hold pet data
  final ImagePicker _picker = ImagePicker();
  File? _image; // Variable to hold the selected image

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pet profiles row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: pets.map((pet) => _buildPetAvatar(pet['name']!, pet['photo']!, true, pet)).toList(),
              ),
              SizedBox(height: 20),
              _buildPetProfileCard(context),
              SizedBox(height: 20),
              _buildPrescriptionsSection(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPetDialog(context),
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF405D72),
      ),
    );
  }

  void _showAddPetDialog(BuildContext context) {
    String name = '';
    String species = '';
    String breed = '';
    String age = '';
    String sex = 'Male'; // Default selection
    String weight = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Pet'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Name'),
                  onChanged: (value) => name = value,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Species'),
                  onChanged: (value) => species = value,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Breed'),
                  onChanged: (value) => breed = value,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => age = value,
                ),
                DropdownButtonFormField<String>(
                  value: sex,
                  decoration: InputDecoration(labelText: 'Sex'),
                  onChanged: (String? newValue) {
                    sex = newValue!;
                  },
                  items: <String>['Male', 'Female']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Weight (lbs)'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => weight = value,
                ),
                SizedBox(height: 10),
                _image == null
                    ? Text('No image selected.')
                    : Image.file(_image!, height: 100, width: 100),
                TextButton(
                  onPressed: () async {
                    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      setState(() {
                        _image = File(pickedFile.path);
                      });
                    }
                  },
                  child: Text('Pick an Image'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _addPet(name, species, breed, age, sex, weight, _image);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addPet(String name, String species, String breed, String age, String sex, String weight, File? imageFile) async {
    String photo = ''; // Initialize photo variable

    if (imageFile != null) {
      // If an image is selected, you can upload it to your server and get the URL
      // Here we'll just simulate by using the local file path
      photo = imageFile.path; // Use the file path temporarily
    } else {
      photo = 'assets/default_pet.jpg'; // Use a default image if none is selected
    }

    final response = await http.post(
      Uri.parse('http://localhost/pet_management/api/pets.php?action=add'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "name": name,
        "species": species,
        "breed": breed,
        "age": age,
        "sex": sex,
        "weight": weight,
        "photo": photo,
        "ownerid": 1, // Adjust based on your requirements
      }),
    );

    if (response.statusCode == 200) {
      // If the server returns an OK response, parse the JSON
      setState(() {
        pets.add({
          'name': name,
          'species': species,
          'breed': breed,
          'age': age,
          'sex': sex,
          'weight': weight,
          'photo': photo,
        });
      });
    } else {
      throw Exception('Failed to add pet');
    }
  }

  Widget _buildPetAvatar(String name, String imagePath, bool isSelected, Map<String, String> pet) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PetDetailPage(pet: pet),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            decoration: isSelected
                ? BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.teal, width: 2),
                  )
                : null,
            child: CircleAvatar(
              backgroundImage: imagePath.startsWith('http')
                  ? NetworkImage(imagePath) // Use NetworkImage for URL
                  : FileImage(File(imagePath)), // Use FileImage for local file
              radius: isSelected ? 30 : 25,
            ),
          ),
          SizedBox(height: 5),
          Text(name),
        ],
      ),
    );
  }

  Widget _buildPetProfileCard(BuildContext context) {
    if (pets.isEmpty) {
      return Center(child: Text('No pets added yet.'));
    }

    var pet = pets[0]; // Display the first pet's details

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: pet['photo']!.startsWith('http')
                    ? NetworkImage(pet['photo']!) // Use NetworkImage for URL
                    : FileImage(File(pet['photo']!)), // Use FileImage for local file
              ),
              title: Text(pet['name']!, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${pet['sex']} · ${pet['breed']} · ${pet['weight']} lbs · ${pet['age']} years old'),
            ),
            Divider(),
            _buildPetInfoRow(Icons.pets, 'Breed', pet['breed']!),
            _buildPetInfoRow(Icons.cake, 'Age', pet['age']!),
            _buildPetInfoRow(Icons.monitor_weight, 'Weight', pet['weight']!),
            _buildPetInfoRow(Icons.male, 'Sex', pet['sex']!),
          ],
        ),
      ),
    );
  }

  Widget _buildPetInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal),
          SizedBox(width: 10),
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.w600)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildPrescriptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Prescriptions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        SizedBox(height: 10),
        _buildPrescriptionCard('Trifexis 50 lbs', 'June 11, 2024'),
        SizedBox(height: 10),
        _buildPrescriptionCard('Frontline', 'July 1, 2024'),
      ],
    );
  }

  Widget _buildPrescriptionCard(String title, String date) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text('Date: $date'),
      ),
    );
  }
}

class PetDetailPage extends StatelessWidget {
  final Map<String, String> pet;

  PetDetailPage({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pet['name']!),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: pet['photo']!.startsWith('http')
                  ? NetworkImage(pet['photo']!) // Use NetworkImage for URL
                  : FileImage(File(pet['photo']!)), // Use FileImage for local file
            ),
            SizedBox(height: 20),
            Text(pet['name']!, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Breed: ${pet['breed']}'),
            Text('Age: ${pet['age']} years'),
            Text('Weight: ${pet['weight']} lbs'),
            Text('Sex: ${pet['sex']}'),
          ],
        ),
      ),
    );
  }
}
