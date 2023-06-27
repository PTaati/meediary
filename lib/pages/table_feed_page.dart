import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meediary/constants/globals.dart';
import 'package:meediary/data_models/post.dart';
import 'package:meediary/services/post_services.dart';
import 'package:provider/provider.dart';

class TableFeedPage extends StatelessWidget {
  const TableFeedPage({super.key});

  Widget _buildImageTile(Post post, BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          barrierColor: Colors.black,
          context: context,
          builder: (context) {
            return InteractiveViewer(
              child: Image.file(
                File(post.imagePath!),
                fit: BoxFit.contain,
              ),
            );
          },
        );
      },
      child: Image.file(
        File(post.imagePath!),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildImageGrid(List<Post> posts, BuildContext context) {
    return GridView.count(
      controller: feedScrollController,
      primary: false,
      crossAxisSpacing: 2,
      mainAxisSpacing: 2,
      crossAxisCount: 3,
      children: posts.map((post) => _buildImageTile(post, context)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final postService = Provider.of<PostService>(context);
    final imagePosts =
        postService.posts.where((post) => post.imagePath != null).toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildImageGrid(imagePosts, context),
      ),
    );
  }
}
