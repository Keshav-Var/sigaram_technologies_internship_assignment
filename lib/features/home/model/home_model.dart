class VideoModel {
  final String id;
  final String title;
  final String link;

  VideoModel({required this.id, required this.title, required this.link});

  factory VideoModel.fromFirestore(String id, Map<String, dynamic> json) {
    return VideoModel(
      id: id,
      title: json['title'] ?? '',
      link: json['link'] ?? '',
    );
  }
}
