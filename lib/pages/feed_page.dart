import 'package:flutter/material.dart';
import 'package:meediary/services/post_services.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    final postService = Provider.of<PostService>(context);

    return ListView.separated(
      itemCount: postService.posts.length,
      itemBuilder: (BuildContext context, int index) {
        final post = postService.posts[index];
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                post.title,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              Text(
                post.created.toString(),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(color: Colors.white54,);
      },
    );
  }
}
