import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../models/event.dart';
import '../services/api_service.dart';
import 'AddTicketScreen.dart';

class UpdateEventScreen extends StatefulWidget {
  final Event event;

  UpdateEventScreen({required this.event});

  @override
  _UpdateEventScreenState createState() => _UpdateEventScreenState();
}

class _UpdateEventScreenState extends State<UpdateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _addressController;
  late TextEditingController _organizerController;
  bool _isLoading = false;
  File? _selectedImage;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _descriptionController =
        TextEditingController(text: widget.event.description);
    _addressController = TextEditingController(text: widget.event.adress);
    _organizerController =
        TextEditingController(text: widget.event.organizer);
    _selectedDate = widget.event.date!;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _organizerController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

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

  Future<void> _updateEvent() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Event updatedEvent = Event(
        id: widget.event.id,
        title: _titleController.text,
        description: _descriptionController.text,
        adress: _addressController.text,
        organizer: _organizerController.text,
        date: _selectedDate,
      );

      try {
        await ApiService().updateEvent(updatedEvent, _selectedImage);
        Navigator.pushReplacementNamed(context, '/'); // Navigate to the welcome screen
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print('Failed to update event: $e');
        // Handle error, e.g., show error message
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Event'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration:
                InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _organizerController,
                decoration:
                InputDecoration(labelText: 'Organizer'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event organizer';
                  }
                  return null;
                },
              ),
              TextButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null &&
                      pickedDate != _selectedDate) {
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
              SizedBox(height: 20),
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
                _selectedImage!,
                height: 200,
                width: 200,
              )
                  : Container(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateEvent,
                child: Text('Update Event'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddTicketScreen(event: widget.event,)),
                  );
                },
                child: Text('Add Ticket'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
