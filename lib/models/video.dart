class Video {
  final String id;
  final String videoFile;
  final String thumbnail;
  final String title;
  final String description;
  final int time;
  final int views;
  final bool isPublished;
  final String owner;
  final DateTime createdAt;
  final DateTime updatedAt;

  Video({
    required this.id,
    required this.videoFile,
    required this.thumbnail,
    required this.title,
    required this.description,
    required this.time,
    required this.views,
    required this.isPublished,
    required this.owner,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['_id'] ?? '',
      videoFile: json['videoFile'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      time: json['time'] ?? 0,
      views: json['views'] ?? 0,
      isPublished: json['isPublished'] ?? false,
      owner: json['owner'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'videoFile': videoFile,
      'thumbnail': thumbnail,
      'title': title,
      'description': description,
      'time': time,
      'views': views,
      'isPublished': isPublished,
      'owner': owner,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
