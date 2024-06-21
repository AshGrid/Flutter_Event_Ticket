
class Ticket {
  final String? id;
  final String? event;
  final double? price;
  final String? type;
  final bool? available;

  Ticket({
     this.id,
     this.event,
     this.price,
     this.type,
     this.available,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['_id'] as String,
      price: (json['price'] as num).toDouble(),
      type: json['type'] as String,
      available: json['available'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event': event,
      'price': price,
      'type': type,

    };
  }
}