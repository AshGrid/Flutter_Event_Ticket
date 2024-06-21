import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../models/event.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

import '../models/ticket.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<Event>> fetchEvents() async {
    final response = await http.get(Uri.parse('$baseUrl/events'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }



   final Dio _dio = Dio();



 Future<void> createEvent(Event event, File? imageFile) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/events'));

    // Add event data
    request.fields['title'] = event.title;
    request.fields['description'] = event.description;
    request.fields['date'] = event.date.toIso8601String();
    request.fields['adress'] = event.adress;
    request.fields['organizer'] = event.organizer;

    // Add image file
    if (imageFile != null) {
      String? mimeType = lookupMimeType(imageFile.path);
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType.parse(mimeType ?? 'application/octet-stream'),
        ),
      );
    }

    var response = await request.send();

    if (response.statusCode != 201) {
      throw Exception('Failed to create event');
    }
  }

  Future<Map<String, dynamic>> getTicketsByEventId(String eventId) async {
    final url = Uri.parse('$baseUrl/ticketsByEvent');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'eventId': eventId}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load tickets');
    }
  }

 Future<void> updateTicket(String? id) async {
    final String apiUrl = '$baseUrl/ticket/buy';
    final Map<String, dynamic> body = {'id': id};
    print('Request Body: ${jsonEncode(body)}'); // Log the request body for debugging

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update ticket: ${response.statusCode}');
    }
  }

  Future<void> deleteEvent(String eventId) async {
    final String apiUrl = '$baseUrl/delEvent/$eventId'; // Assuming endpoint is /events/:id
print("delete$eventId");
    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 204) {
        print('Event deleted successfully');
      } else {
        throw Exception('Failed to delete event: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to delete event: $e');
      throw Exception('Failed to delete event: $e');
    }
  }

  Future<void> updateEvent(Event event, File? imageFile) async {
    var request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/events'));

    // Add event data
    request.fields['id'] = event.id!;
    request.fields['title'] = event.title;
    request.fields['description'] = event.description;
    request.fields['date'] = event.date.toIso8601String();
    request.fields['adress'] = event.adress;
    request.fields['organizer'] = event.organizer;

    // Add image file
    if (imageFile != null) {
      String? mimeType = lookupMimeType(imageFile.path);
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType.parse(mimeType ?? 'application/octet-stream'),
        ),
      );
    }

    var response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Failed to create event');
    }
  }

  Future<Ticket> createTicket(Ticket ticket) async {
    final url = Uri.parse('$baseUrl/tickets');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(ticket.toJson()),
    );

    if (response.statusCode == 201) {
      return Ticket.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create ticket');
    }
  }

}
