import 'package:event/main.dart';
import 'package:event/screens/update_event_screen.dart';
import 'package:event/services/api_service.dart';
import 'package:flutter/material.dart';
import '../models/event.dart';
import '../models/ticket.dart';
import 'event_list_screen.dart';
import 'tickets_list.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  EventDetailsScreen({required this.event});

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final ApiService _apiService = ApiService();
  List<Ticket> _tickets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTickets();
  }

  Future<void> _fetchTickets() async {
    try {
      final response = await _apiService.getTicketsByEventId(widget.event.id!);
      setState(() {
        _tickets = response['tickets']
            .map<Ticket>((ticket) => Ticket.fromJson(ticket))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching tickets: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String imageUrl = 'http://192.168.163.1:8080/${widget.event.img}';
    final ApiService _apiService = ApiService();

    Future<void> _deleteEvent(String eventId) async {
      try {
        await _apiService.deleteEvent(eventId);
        // Handle successful deletion, e.g., navigate back to event list
      } catch (e) {
        // Handle error, e.g., show error message
        print('Failed to delete event: $e');
        // Implement error handling as needed
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Title: ${widget.event.title}',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text('ID: ${widget.event.id}'),
                            Text('Date: ${widget.event.date?.toLocal()}'),
                            Text('Location: ${widget.event.adress}'),
                            Text('Organizer: ${widget.event.organizer}'),
                            Text('Description: ${widget.event.description}'),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: imageUrl.isNotEmpty
                            ? Image.network(
                                imageUrl,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Container(),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirm Deletion'),
                                content: Text('Are you sure you want to delete this event?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context); // Close the dialog
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      try {
                                        await _apiService.deleteEvent(widget.event.id!);
                                        // Handle successful deletion, e.g., navigate back to event list
                                        //Navigator.pushNamedAndRemoveUntil(context, '/welcome', (Route<dynamic> route) => false);// Pop all routes until reaching the home screen
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          '/',
                                              (Route<dynamic> route) => false,
                                        );
                                      } catch (e) {
                                        // Handle error, e.g., show error message
                                        print('Failed to delete event: $e');
                                        // Implement error handling as needed
                                      }
                                    },
                                    child: Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text('Delete'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateEventScreen(event: widget.event),
                            ),
                          );
                          // TODO: Implement update action
                        },
                        child: Text('Update'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Tickets',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: TicketsList(initialTickets: _tickets, eventId: widget.event.id!,),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
