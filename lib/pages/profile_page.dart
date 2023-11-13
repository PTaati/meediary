import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meediary/constants/routes.dart';
import 'package:meediary/data_models/post.dart';
import 'package:meediary/data_models/user.dart';
import 'package:meediary/services/post_services.dart';
import 'package:meediary/services/snackbar_service.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Widget _buildProfileDetail(User user) {
    String? dateOfBirth;

    if (user.dateOfBirth != null) {
      dateOfBirth = DateFormat('EEEE, MMM d, yyyy').format(
        user.dateOfBirth!,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey,
            foregroundImage: user.avatarPath != null
                ? Image.file(File(user.avatarPath!)).image
                : null,
            child: const Icon(
              Icons.person,
              size: 100,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(RouteNames.editProfilePage);
            },
            child: const Text(
              'แก้ไขข้อมูล',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            user.name ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          if (dateOfBirth != null)
            Text(
              dateOfBirth,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          if (user.note != null)
            Text(
              user.note!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            )
        ],
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

  Widget _buildSettings() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(RouteNames.settingPage);
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.grey,
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final postService = Provider.of<PostService>(context);
    // final imagePosts =
    //     postService.posts.where((post) => post.imagePath != null).toList();

    final user = Provider.of<User>(context);

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSettings(),
          Expanded(child: _buildProfileDetail(user)),
          // const Divider(
          //   color: Colors.white24,
          // ),
          // Expanded(child: _buildImageGrid(imagePosts)),
        ],
      ),
    );
  }
}
