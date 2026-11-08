import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class PostService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Post>> fetchPosts() => _guard(() async {
        final uri = Uri.parse('$_baseUrl/posts'); // 1. buat alamat
        final response = await http.get(uri);     // 2. kirim request
        if (response.statusCode != 200) {         // 3. cek status code
          throw Exception('Gagal memuat pengumuman (${response.statusCode})');
        }
        final List<dynamic> data = jsonDecode(response.body); // 4. JSON -> objek
        return data.map((e) => Post.fromJson(e)).toList();
      });

  Future<List<Comment>> fetchComments(int postId) => _guard(() async {
        final uri = Uri.parse('$_baseUrl/posts/$postId/comments');
        final response = await http.get(uri);
        if (response.statusCode != 200) {
          throw Exception('Gagal memuat komentar (${response.statusCode})');
        }
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => Comment.fromJson(e)).toList();
      });

  Future<Post> createPost(Post post) => _guard(() async {
        final uri = Uri.parse('$_baseUrl/posts');
        final response = await http.post(
          uri,
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode(post.toJson()),
        );
        if (response.statusCode != 201) {
          throw Exception('Gagal membuat pengumuman (${response.statusCode})');
        }
        return Post.fromJson(jsonDecode(response.body));
      });

  // Mengubah error jaringan menjadi pesan yang mudah dibaca
  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action().timeout(const Duration(seconds: 10));
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on TimeoutException {
      throw Exception('Koneksi terlalu lama. Coba lagi.');
    }
  }
}