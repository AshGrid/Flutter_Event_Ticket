import 'package:flutter/material.dart';
import 'bottom_navigation.dart'; // Import your reusable bottom navigation bar
import 'models/event.dart';
import 'screens/event_form.dart';
import 'screens/event_list_screen.dart';
import 'screens/welcomeScreen.dart';

import 'services/api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event App',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: HomeScreen(),
      routes: {
        '/welcome': (context) => WelcomeScreen(),
        // Define other routes if needed
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EVENTS"),
      ),
      body: Center(
        child: _getPage(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _getPage(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return WelcomeScreen();
      case 1:
        return EventForm();
      case 2:
        return FutureBuilder<List<Event>>(
          future: _apiService.fetchEvents(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Event> events = snapshot.data ?? [];
              return EventListScreen(events: events);
            }
          },
        );
      default:
        return Container();
    }
  }
}
