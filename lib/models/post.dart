class Post {
  final int? id;
  final int userId;
  final String title;
  final String body;

  Post({this.id, required this.userId, required this.title, required this.body});

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json['id'],
        userId: json['userId'],
        title: json['title'],
        body: json['body'],
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'title': title,
        'body': body,
      };
}

// Model kecil untuk komentar (disimpan di file yang sama agar struktur folder tetap sesuai)
class Comment {
  final int id;
  final String name;
  final String email;
  final String body;

  Comment({required this.id, required this.name, required this.email, required this.body});

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        body: json['body'],
      );
}