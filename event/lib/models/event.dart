import 'dart:io';

import 'ticket.dart';
class Event {
  final String? id;
  final String title;
  final String description;
  final DateTime date;
  final String adress;
  final String organizer;
  final File? image;
  final List<Ticket>? tickets;
  final String? img;

  Event({
     this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.adress,
    required this.organizer,
     this.image,
     this.tickets,
     this.img,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      adress: json['adress'] as String,
      organizer: json['organizer'] as String,
      img: json['image'] as String,
      tickets: (json['tickets'] as List<dynamic>)
          .map((e) => Ticket.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'adress': adress,
      'organizer': organizer,
      'image': image,
      'tickets': tickets?.map((e) => e.toJson()).toList(),
    };
  }
}
