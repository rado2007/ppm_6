import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/post_service.dart';

class DetailScreen extends StatefulWidget {
  final Post post;
  const DetailScreen({super.key, required this.post});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _service = PostService();
  late Future<List<Comment>> _comments;

  @override
  void initState() {
    super.initState();
    _comments = _service.fetchComments(widget.post.id!);
  }

  void _reload() {
    setState(() {
      _comments = _service.fetchComments(widget.post.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pengumuman')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(post.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Text(post.body),
          const Divider(height: 32),
          Text('Komentar', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          FutureBuilder<List<Comment>>(
            future: _comments,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                final msg =
                    snapshot.error.toString().replaceFirst('Exception: ', '');
                return Column(
                  children: [
                    Text(msg),
                    TextButton(
                        onPressed: _reload, child: const Text('Coba Lagi')),
                  ],
                );
              }
              return Column(
                children: snapshot.data!
                    .map((c) => Card(
                          child: ListTile(
                            title: Text(c.name),
                            subtitle: Text('${c.email}\n${c.body}'),
                            isThreeLine: true,
                          ),
                        ))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}