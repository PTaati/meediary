import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meediary/constants/globals.dart';
import 'package:meediary/data_models/post.dart';
import 'package:meediary/services/post_services.dart';
import 'package:provider/provider.dart';

class AddNewPostPage extends StatefulWidget {
  const AddNewPostPage({Key? key}) : super(key: key);

  @override
  State<AddNewPostPage> createState() => _AddNewPostPageState();
}

class _AddNewPostPageState extends State<AddNewPostPage> {
  bool _canSave = false;
  final TextEditingController _textEditingController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  String? imagePath;

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
          const Text(
            'เพิ่มบันทึก',
            style: TextStyle(fontSize: 24),
          ),
          IconButton(
            onPressed: _canSave
                ? () {
                    final postService =
                        Provider.of<PostService>(context, listen: false);
                    final post = Post(
                      title: _textEditingController.text,
                      description: '',
                      created: DateTime.now(),
                      imagePath: imagePath,
                    );
                    postService.post(post);

                    const snackBar = SnackBar(
                      backgroundColor: Colors.grey,
                      content: Text(
                        'บันทึกเรียบร้อย',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      duration: Duration(seconds: 2),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
          File(imagePath!),
          fit: BoxFit.fitWidth,
        ),
        Positioned(
          right: 0,
          top: 0,
          child: IconButton(
            icon: const Icon(Icons.cancel, color: Colors.white),
            onPressed: () {
              setState(() {
                imagePath = null;
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
                if (value.isNotEmpty) {
                  setState(() {
                    _canSave = true;
                  });
                }
              },
            ),
            if (imagePath != null) _buildImage(),
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
                imagePath = image.path;
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
                imagePath = image.path;
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
