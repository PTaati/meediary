import 'package:flutter/material.dart';
import 'package:meediary/constants/globals.dart';
import 'package:meediary/services/post_services.dart';
import 'package:meediary/widgets/post_card.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final postService = Provider.of<PostService>(context);

    return Container(
      color: Colors.white24,
      child: ListView(
        controller: feedScrollController,
        children: postService.posts
            .map((post) => PostCard(
                  post: post,
                ))
            .toList(),
      ),
    );
  }
}
