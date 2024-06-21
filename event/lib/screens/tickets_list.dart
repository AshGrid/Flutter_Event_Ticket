import 'package:event/services/api_service.dart';
import 'package:flutter/material.dart';
import '../models/ticket.dart';

class TicketsList extends StatefulWidget {
  final List<Ticket> initialTickets;
  final String eventId;

  TicketsList({required this.initialTickets, required this.eventId});

  @override
  _TicketsListState createState() => _TicketsListState();
}

class _TicketsListState extends State<TicketsList> {
  late List<Ticket> _tickets;

  @override
  void initState() {
    super.initState();
    _tickets = widget.initialTickets;
  }

  Future<void> _refreshTickets() async {
    try {
      final response = await ApiService().getTicketsByEventId(widget.eventId);
      setState(() {
        _tickets = response['tickets']
            .map<Ticket>((ticket) => Ticket.fromJson(ticket))
            .toList();
      });
    } catch (e) {
      print('Error fetching tickets: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _tickets.isEmpty
        ? Text('No tickets available')
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _tickets.length,
            itemBuilder: (context, index) {
              final ticket = _tickets[index];
              return Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(ticket.type!),
                  subtitle: Text('Price: \$${ticket.price}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Available: ${ticket.available! ? 'Yes' : 'No'}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ticket.available! ? Colors.green : Colors.red,
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: ticket.available! ? () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Buy Ticket'),
                                content: Text(
                                    'Do you want to buy a ticket for ${ticket.type}?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context); // Close the dialog
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await ApiService().updateTicket(ticket.id);
                                      Navigator.pop(context); // Close the dialog
                                      await _refreshTickets(); // Refresh tickets list
                                    },
                                    child: Text('Buy'),
                                  ),
                                ],
                              );
                            },
                          );
                        } : null, // Disable the button if the ticket is not available
                        child: Text('Buy Ticket'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
