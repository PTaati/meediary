import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meediary/constants/globals.dart';
import 'package:meediary/data_models/post.dart';
import 'package:meediary/services/post_services.dart';
import 'package:meediary/services/snackbar_service.dart';
import 'package:meediary/utils/file_utils.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

class CreateOrEditPostPage extends StatefulWidget {
  const CreateOrEditPostPage({this.post, Key? key}) : super(key: key);

  final Post? post;

  @override
  State<CreateOrEditPostPage> createState() => _CreateOrEditPostPageState();
}

class _CreateOrEditPostPageState extends State<CreateOrEditPostPage> {
  bool _canSave = false;
  final TextEditingController _textEditingController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  XFile? xFile;
  late RiveAnimationController _controller;
  bool _deleteOldImage = false;

  @override
  void initState() {
    super.initState();
    _controller = SimpleAnimation('idle');

    if (widget.post != null){
      _textEditingController.text = widget.post?.title ?? '';
      if (_textEditingController.text.isNotEmpty){
        _canSave = true;
      }
    }
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.close),
          ),
          Text(
            widget.post != null ? 'แก้ไขบันทึก' :'เพิ่มบันทึก',
            style: const TextStyle(fontSize: 24),
          ),
          IconButton(
            onPressed: _canSave
                ? () async {
                    final postService =
                        Provider.of<PostService>(context, listen: false);
                    String? imagePath;

                    if (xFile != null) {
                      imagePath = await saveFileInApp(xFile!);
                    }

                    if (widget.post == null) {
                      final post = Post(
                        title: _textEditingController.text,
                        description: '',
                        created: DateTime.now(),
                        imagePath: imagePath,
                      );

                      postService.post(post);
                    } else {
                      final post = widget.post!;
                      post.title = _textEditingController.text;
                      post.imagePath = imagePath ?? (_deleteOldImage ? null : post.imagePath);

                      postService.updatePost(post);
                    }


                    if (!mounted){
                      return;
                    }

                    SnackBarService.showSnackBar('บันทึกเรียบร้อย', context);

                    feedScrollController.animateTo(0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.fastOutSlowIn);
                    Navigator.of(context).pop();
                  }
                : null,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
    );
  }

  Widget _buildRowAction(Icon icon, String label, Future Function() onTap) {
    return GestureDetector(
      excludeFromSemantics: true,
      onTap: onTap,
      child: Column(
        children: [
          const Divider(
            color: Colors.white54,
          ),
          SizedBox(
            height: 50,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                icon,
                const SizedBox(
                  width: 20,
                ),
                Text(
                  label,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Stack(
      children: [
        Image.file(
          File(widget.post?.imagePath ?? xFile!.path),
          fit: BoxFit.fitWidth,
        ),
        Positioned(
          right: 0,
          top: 0,
          child: IconButton(
            icon: const Icon(Icons.cancel, color: Colors.white),
            onPressed: () {
              setState(() {
                if (widget.post?.imagePath != null){
                  _deleteOldImage = true;
                }

                xFile = null;

                if (_textEditingController.text.isEmpty){
                  _canSave = false;
                }
              });
            },
          ),
        )
      ],
    );
  }



  Widget _buildBodySection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: _textEditingController,
              maxLines: 5,
              cursorColor: Colors.white54,
              decoration: const InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: 'วันนี้เธอพบเจออะไรมาหรอ ?',
              ),
              onChanged: (value) {
                if (value.isNotEmpty || xFile != null) {
                  setState(() {
                    _canSave = true;
                  });
                } else {
                  setState(() {
                    _canSave = false;
                  });
                }
              },
            ),
            if (xFile != null || (widget.post?.imagePath != null && !_deleteOldImage)) _buildImage(),
            _buildRowAction(
                const Icon(
                  Icons.image,
                  color: Colors.green,
                ),
                'รูปภาพ/วิดีโอ', () async {
              final XFile? image =
                  await picker.pickImage(source: ImageSource.gallery);
              if (!mounted || image == null) {
                return;
              }
              setState(() {
                xFile = image;
                _canSave = true;
              });
            }),
            _buildRowAction(
                const Icon(
                  Icons.camera_alt,
                  color: Colors.redAccent,
                ),
                'ถ่ายรูป', () async {
              final XFile? image =
                  await picker.pickImage(source: ImageSource.camera);
              if (!mounted || image == null) {
                return;
              }
              setState(() {
                xFile = image;
                _canSave = true;
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildHeaderSection(),
        const Divider(
          color: Colors.white54,
        ),
        Expanded(child: _buildBodySection()),
        // SizedBox(
        //   height: 300,
        //   child: RiveAnimation.asset(
        //     'assets/3984-8296-car.riv',
        //     controllers: [_controller],
        //     fit: BoxFit.cover,
        //   ),
        // )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildBody(),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
