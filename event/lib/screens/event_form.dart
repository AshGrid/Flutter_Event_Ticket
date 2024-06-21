import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../models/event.dart';
import '../screens/event_list_screen.dart';
import '../services/api_service.dart';

class EventForm extends StatefulWidget {
  const EventForm({Key? key}) : super(key: key);

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _eventNameController = TextEditingController();
  TextEditingController _eventDescriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TextEditingController _eventLocationController = TextEditingController();
  TextEditingController _eventOrganizerController = TextEditingController();
  File? _selectedImage; // Use String to store the image URL

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? pickedFile;

    pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Extract the file extension from the selected file
      String fileExtension = pickedFile.path.split('.').last;

      // Generate a unique name using the current timestamp
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String imageName = 'image_$timestamp.$fileExtension';

      // Get the app's documents directory
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;

      // Construct the destination path in the documents directory
      String destinationPath = '$appDocPath/$imageName';

      // Move the file to the destination path
      await File(pickedFile.path).copy(destinationPath);

      setState(() {
        // Store the path in _selectedImage
        _selectedImage = File(destinationPath);
      });
    }
  }

  Future<void> _addEventToDatabase(Event newEvent,File file) async {
    
    

    try {
        ApiService().createEvent(newEvent,file);

      
    } catch (error) {
      print('Error adding event to the database: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Event"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _eventNameController,
                decoration: InputDecoration(labelText: 'Event Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _eventDescriptionController,
                decoration: InputDecoration(labelText: 'Event Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null && pickedDate != _selectedDate) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
                child: Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 8),
                    Text('Select Event Date'),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                '${_selectedDate.toLocal()}'.split(' ')[0],
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _eventLocationController,
                decoration: InputDecoration(labelText: 'Event Location'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _eventOrganizerController,
                decoration: InputDecoration(labelText: 'Event Organizer'),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: _pickImage,
                child: Row(
                  children: [
                    Icon(Icons.image),
                    SizedBox(width: 8),
                    Text('Select Event Image'),
                  ],
                ),
              ),
              SizedBox(height: 16),
              _selectedImage != null
                  ? Image.file(
                      (_selectedImage!),
                      height: 200,
                      width: 200,
                    )
                  : Container(),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Event newEvent = Event(
                      
                      title: _eventNameController.text,
                      description: _eventDescriptionController.text,
                      date: _selectedDate,
                      adress: _eventLocationController.text,
                      organizer: _eventOrganizerController.text,
                      
                    );

                    await _addEventToDatabase(newEvent,_selectedImage as File);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Event added: ${newEvent.title} on ${newEvent.date}'),
                      ),
                    );
                  }
                },
                child: Text('Add Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
