import 'package:flutter/material.dart';
import '../models/event.dart';
import '../models/ticket.dart';
import '../services/api_service.dart';

class AddTicketScreen extends StatefulWidget {
  final Event event;

  AddTicketScreen({required this.event});

  @override
  _AddTicketScreenState createState() => _AddTicketScreenState();
}

class _AddTicketScreenState extends State<AddTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _priceController;
  bool _isLoading = false;
  String? _selectedTicketType;

  final List<String> ticketTypes = ['General', 'VIP',  'Student'];

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController();
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _createTicket() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Ticket newTicket = Ticket(
        id: '',
        event: widget.event.id,
        type: _selectedTicketType!,
        price: double.parse(_priceController.text),
      );

      try {
        await ApiService().createTicket(newTicket);
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/',
              (Route<dynamic> route) => false,
        ); // Return to the previous screen
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print('Failed to create ticket: $e');
        // Handle error, e.g., show error message
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Ticket for ${widget.event.title}'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Ticket Type'),
                value: _selectedTicketType,
                items: ticketTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTicketType = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please choose the ticket type';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Ticket Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the ticket price';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createTicket,
                child: Text('Create Ticket'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
