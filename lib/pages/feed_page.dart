import 'package:flutter/material.dart';
import 'package:meediary/constants/globals.dart';
import 'package:meediary/pages/table_feed_page.dart';
import 'package:meediary/services/post_services.dart';
import 'package:meediary/widgets/post_card.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  bool _isFeed = true;

  Widget _buildSwitchMode() {
    return IconButton(
      onPressed: () {
        setState(() {
          _isFeed = !_isFeed;
        });
      },
      icon: const Icon(Icons.switch_access_shortcut, color: Colors.white30,),
    );
  }

  @override
  Widget build(BuildContext context) {
    final postService = Provider.of<PostService>(context);

    return SafeArea(
      child: Stack(
        children: [
          _isFeed ? Container(
            color: Colors.white24,
            child: ListView(
              controller: feedScrollController,
              children: postService.posts
                  .map((post) => PostCard(
                        post: post,
                      ))
                  .toList(),
            ),
          ) : const TableFeedPage(),
          Align(alignment: Alignment.topLeft, child: _buildSwitchMode()),
        ],
      ),
    );
  }
}
