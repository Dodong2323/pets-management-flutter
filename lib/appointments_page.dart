import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryCard('Upcoming', '5', Colors.teal),
                _buildSummaryCard('Completed', '10', Colors.green),
                _buildSummaryCard('Cancelled', '2', Colors.red),
              ],
            ),
            SizedBox(height: 20),
            TableCalendar(
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2024, 12, 31),
              focusedDay: DateTime.now(),
              onDaySelected: (selectedDay, focusedDay) {
                // Handle day selection
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.teal,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.teal.shade200,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 3, // Example item count
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    elevation: 5,
                    child: ListTile(
                      title: Text('Appointment ${index + 1}'),
                      subtitle: Text('Date: ${index + 1}/10/2024\nTime: 10:00 AM'),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        // Navigate to appointment details
                      },
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Action to schedule a new appointment
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
              ),
              child: Text('Schedule Appointment'), // Added button text
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(16),
        width: 120, // Increased width for better readability
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center, // Center text
            ),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
              textAlign: TextAlign.center, // Center text
            ),
          ],
        ),
      ),
    );
  }
}
