class Activity {
  final String aid;
  final String name;
  final List<dynamic> images;
  final String tag;
  final String description;
  final String address;
  final String price;
  final Map<String, String> hoo;

  Activity({
    this.aid,
    this.name,
    this.images,
    this.description,
    this.tag,
    this.address,
    this.price,
    this.hoo,
  });

  Activity.fromJson(Map<String, dynamic> data)
      : aid = data['aid'],
        name = data['name'] ?? '',
        images = data['images'] ?? [],
        description = data['description'] ?? '',
        tag = data['tag'] ?? '',
        address = data['address'] ?? '',
        price = data['price'] ?? '',
        hoo = data['hoo'] ?? {};

  Map<String, dynamic> toJson() => {
        'aid': aid,
        'name': name,
        'images': images,
        'description': description,
        'tag': tag,
        'address': address,
        'price': price,
        'hoo': hoo,
      };
}
