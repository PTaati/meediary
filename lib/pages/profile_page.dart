import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meediary/data_models/post.dart';
import 'package:meediary/services/post_services.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Widget _buildProfileDetail() {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: SizedBox(
        height: 200,
        child: Column(
          children: const [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                size: 100,
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Taati",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildImageTile(Post post) {
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

  Widget _buildImageGrid(List<Post> posts) {
    return GridView.count(
      primary: false,
      crossAxisSpacing: 2,
      mainAxisSpacing: 2,
      crossAxisCount: 3,
      children: posts.map((post) => _buildImageTile(post)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final postService = Provider.of<PostService>(context);
    final imagePosts =
        postService.posts.where((post) => post.imagePath != null).toList();

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildProfileDetail(),
          const Divider(
            color: Colors.white24,
          ),
          Expanded(child: _buildImageGrid(imagePosts)),
        ],
      ),
    );
  }
}
