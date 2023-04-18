import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meediary/data_models/post.dart';
import 'package:provider/provider.dart';

import '../services/post_services.dart';

class PostCard extends StatefulWidget {
  const PostCard({
    required this.post,
    Key? key,
  }) : super(key: key);

  final Post post;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late PostService postService;

  @override
  void initState() {
    super.initState();

    postService = Provider.of<PostService>(context, listen: false);
  }

  Widget _buildLike() {
    return GestureDetector(
      excludeFromSemantics: true,
      onTap: () {
        setState(() {
          widget.post.isLike = !widget.post.isLike;
          postService.postBox.put(widget.post);
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            widget.post.isLike ? Icons.favorite : Icons.favorite_outline,
            color: Colors.white,
          ),
          const SizedBox(
            width: 10,
          ),
          const Text(
            'ถูกใจ',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComment() {
    return GestureDetector(
      excludeFromSemantics: true,
      onTap: () {},
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(
            Icons.chat_bubble_outline,
            color: Colors.white,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'แสดงความคิดเห็น',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShare() {
    return GestureDetector(
      excludeFromSemantics: true,
      onTap: () {},
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(
            Icons.share,
            color: Colors.white,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'แชร์',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLike(),
        _buildComment(),
        _buildShare(),
      ],
    );
  }

  Widget _buildPostBody() {
    return Column(
      children: [
        Text(
          widget.post.title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Widget _buildCreatedTime() {
    final timeFormat = DateFormat('EEEE, MMM d, yyyy').format(
      widget.post.created,
    );
    return Text(
      timeFormat,
      style: const TextStyle(
        color: Colors.white54,
        fontSize: 10,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  height: 30,
                ),
                _buildPostBody(),
                const SizedBox(
                  height: 30,
                ),
                _buildBottomMenu(),
              ],
            ),
          ),
          Positioned(left: 10, top: 10, child: _buildCreatedTime()),
        ],
      ),
    );
  }
}
