class ShopModel {
  final int id;
  final String image;
  final String name;
  final String location;
  final String city;
  final bool delivery;
  final bool pickup;
  final String whatsapp;
  final String description;
  final double price;
  final double rate;
  final DateTime createdAt;
  final DateTime updatedAt;

  ShopModel({
    required this.id,
    required this.image,
    required this.name,
    required this.location,
    required this.city,
    required this.delivery,
    required this.pickup,
    required this.whatsapp,
    required this.description,
    required this.price,
    required this.rate,
    required this.createdAt,
    required this.updatedAt,
  });

  ShopModel copyWith({
    int? id,
    String? image,
    String? name,
    String? location,
    String? city,
    bool? delivery,
    bool? pickup,
    String? whatsapp,
    String? description,
    double? price,
    double? rate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      ShopModel(
        id: id ?? this.id,
        image: image ?? this.image,
        name: name ?? this.name,
        location: location ?? this.location,
        city: city ?? this.city,
        delivery: delivery ?? this.delivery,
        pickup: pickup ?? this.pickup,
        whatsapp: whatsapp ?? this.whatsapp,
        description: description ?? this.description,
        price: price ?? this.price,
        rate: rate ?? this.rate,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory ShopModel.fromJson(Map<String, dynamic> json) => ShopModel(
        id: json["id"],
        image: json["image"],
        name: json["name"],
        location: json["location"],
        city: json["city"],
        delivery: json["delivery"] == 1,
        pickup: json["pickup"] == 1,
        whatsapp: json["whatsapp"],
        description: json["description"],
        price: json["price"]?.toDouble(),
        rate: json["rate"]?.toDouble(),
        createdAt: DateTime.parse(json["created_at"]).toLocal(),
        updatedAt: DateTime.parse(json["updated_at"]).toLocal(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
        "location": location,
        "city": city,
        "delivery": delivery ? 1 : 0,
        "pickup": pickup ? 1 : 0,
        "whatsapp": whatsapp,
        "description": description,
        "price": price,
        "rate": rate,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
