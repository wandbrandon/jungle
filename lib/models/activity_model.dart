class Activity {
  final String aid;
  final String name;
  final List<dynamic> images;
  final String tag;
  final String description;
  final String address;
  final String price;
  final String type;
  final int popularity;

  Activity({
    this.popularity,
    this.type,
    this.aid,
    this.name,
    this.images,
    this.description,
    this.tag,
    this.address,
    this.price,
  });

  Activity.fromJson(Map<String, dynamic> data)
      : aid = data['aid'] ?? '',
        popularity = data['popularity'] ?? 0,
        name = data['name'] ?? '',
        images = data['images'] ?? [],
        description = data['description'] ?? '',
        tag = data['tag'] ?? '',
        address = data['address'] ?? '',
        price = data['price'] ?? '',
        type = data['type'] ?? '';

  Map<String, dynamic> toJson() => {
        'aid': aid ?? '',
        'popularity': popularity ?? 0,
        'name': name ?? '',
        'images': images ?? [],
        'description': description ?? '',
        'tag': tag ?? '',
        'address': address ?? '',
        'price': price ?? '',
        'type': type ?? ''
      };
}
