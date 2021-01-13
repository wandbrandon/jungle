class Activity {
  final int aid;
  final String name;
  final List<dynamic> images;
  final List<dynamic> tags;
  final String description;
  final String location;
  final int count;

  Activity({
    this.aid,
    this.name,
    this.images,
    this.description,
    this.tags,
    this.location,
    this.count,
  });

  Activity.fromJson(Map<String, dynamic> data)
      : aid = data['uid'],
        name = data['name'] ?? '',
        images = data['images'] ?? [],
        description = data['description'] ?? '',
        tags = data['tags'] ?? '',
        location = data['location'] ?? '',
        count = data['count'] ?? '';

  Map<String, dynamic> toJson() => {
        'aid': aid,
        'name': name,
        'images': images,
        'description': description,
        'tags': tags,
        'location': tags,
        'count': count,
      };
}
