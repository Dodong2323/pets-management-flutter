import 'package:flutter/material.dart';

class ServicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: ListView(
          children: [
            _buildSectionHeader('Available Services', screenWidth),
            _buildServiceList('Grooming Services', [
              'Paws & Claws Grooming',
              'Furry Friends Grooming',
            ], context),
            _buildServiceList('Boarding Services', [
              'Happy Tails Boarding',
              'Pet Paradise Inn',
            ], context),
            _buildServiceList('Veterinary Services', [
              'Care Pet Clinic',
              'City Animal Hospital',
            ], context),
            _buildServiceList('Training Services', [
              'Canine Academy',
              'Pawsitive Training',
            ], context),
            _buildSectionHeader('Free Local Pet Services', screenWidth),
            _buildServiceList('', [
              'Community Dog Wash Events',
              'Pet Adoption Days',
              'Free Vaccination Clinics',
              'Dog Training Workshops',
              'Pet Care Seminars',
              'Local Animal Shelter Volunteer Days',
              'Pet Meet-and-Greet Events',
            ], context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: screenWidth * 0.06,
          fontWeight: FontWeight.bold,
          color: Colors.teal,
        ),
      ),
    );
  }

  Widget _buildServiceList(String sectionTitle, List<String> services, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (sectionTitle.isNotEmpty)
            Text(
              sectionTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal[600],
              ),
            ),
          SizedBox(height: 5),
          ...services.map((service) => GestureDetector(
            onTap: () => _navigateToServiceDetail(service, context),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Text(
                '• $service',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.teal[700],
                ),
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }

  void _navigateToServiceDetail(String serviceName, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceDetailPage(serviceName: serviceName),
      ),
    );
  }
}

class ServiceDetailPage extends StatelessWidget {
  final String serviceName;

  ServiceDetailPage({required this.serviceName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(serviceName),
        backgroundColor: Color(0xFF405D72),
      ),
      body: Center(
        child: Text(
          'Details about $serviceName will be displayed here.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
