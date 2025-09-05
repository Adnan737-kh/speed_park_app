import 'package:flutter/material.dart';

class SuperUserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Super User Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to the screen to create sub-users
              },
              child: const Text('Create Sub Users'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the screen to create a new location
              },
              child: const Text('Create New Location'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the screen to access reports
              },
              child: const Text('Access Reports'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the screen to create custom reports
              },
              child: const Text('Create Custom Reports'),
            ),
          ],
        ),
      ),
    );
  }
}
