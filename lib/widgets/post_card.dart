import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meediary/data_models/post.dart';
import 'package:meediary/utils/date_time_utils.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

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

  late RiveAnimationController _controller;
  bool _isLikeAnimate = false;

  @override
  void initState() {
    super.initState();

    _controller = SimpleAnimation('idle');
    postService = Provider.of<PostService>(context, listen: false);
  }

  Future<void> _likeAnimation() async {
    _controller = SimpleAnimation('preview');

    setState(() {
      _isLikeAnimate = true;
    });
    await Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) {
        return;
      }
      _controller = SimpleAnimation('idle');

      setState(() {
        _isLikeAnimate = false;
      });
    });
  }

  Future<void> _onTapLike() async {
    setState(() {
      widget.post.isLike = !widget.post.isLike;
      postService.postBox.put(widget.post);
    });

    if (widget.post.isLike) {
      await _likeAnimation();
    }
  }

  Widget _buildLike() {
    return GestureDetector(
      excludeFromSemantics: true,
      onTap: _isLikeAnimate ? null : _onTapLike,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_isLikeAnimate && widget.post.isLike)
            Center(
              child: SizedBox(
                height: 26,
                width: 26,
                child: RiveAnimation.asset(
                  'assets/1683-3324-like-button.riv',
                  controllers: [_controller],
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Icon(
              widget.post.isLike ? Icons.favorite : Icons.favorite_outline,
              size: 26,
              color:
                  widget.post.isLike ? const Color(0xFFF47C7C) : Colors.white,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLike(),
          // _buildComment(),
          _buildCreatedTime(),
          _buildShare(),
        ],
      ),
    );
  }

  Widget _buildImage() {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Stack(
        children: [
          GestureDetector(
            onDoubleTap: () async {
              if (widget.post.isLike) {
                await _likeAnimation();
              } else {
                await _onTapLike();
              }
            },
            onTap: () {
              showDialog(
                barrierColor: Colors.black,
                context: context,
                builder: (context) {
                  return InteractiveViewer(
                    child: Image.file(
                      File(widget.post.imagePath!),
                      fit: BoxFit.contain,
                    ),
                  );
                },
              );
            },
            child: SizedBox(
              width: width,
              height: width,
              child: Image.file(
                File(widget.post.imagePath!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (_isLikeAnimate && widget.post.isLike)
            SizedBox(
              width: width,
              height: width,
              child: Center(
                child: SizedBox(
                  height: width/3,
                  width: width/3,
                  child: RiveAnimation.asset(
                    'assets/1683-3324-like-button.riv',
                    controllers: [_controller],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildPostBody() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            widget.post.title,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        if (widget.post.imagePath != null) _buildImage(),
      ],
    );
  }

  Widget _buildCreatedTime() {
    final timeFormat = displayDateTimeFormat(
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
      color: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
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
    );
  }
}
