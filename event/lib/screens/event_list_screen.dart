// event_list_screen.dart

import 'package:flutter/material.dart';
import '../models/event.dart';
import 'EventDetailsScreen.dart';

import 'dart:io';



class EventListScreen extends StatelessWidget {
  final List<Event> events;

  EventListScreen({required this.events});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event List'),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          Event event = events[index];

          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(event.title!),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date: ${event.date?.toLocal()}'),
                  Text('Location: ${event.adress}'),
                  Text('Organizer: ${event.organizer}'),
                  Text('Description: ${event.description}'),
                  SizedBox(height: 8),
                  // Use Image.file to display the image
                 
                ],
              ),
              onTap: () {
                // TODO: Implement action when tapping on an event
                // You might want to navigate to a detailed view or perform other actions
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetailsScreen(event: event),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}


