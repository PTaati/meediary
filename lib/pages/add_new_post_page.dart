import 'package:flutter/material.dart';
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
                    );
                    postService.post(post);

                    const snackBar = SnackBar(
                      backgroundColor: Colors.white24,
                      content: Text(
                        'บันทึกเรียบร้อย',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      duration: Duration(seconds: 1),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.of(context).pop();
                  }
                : null,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
    );
  }

  Widget _buildRowAction(Icon icon, String label, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          const Divider(
            color: Colors.white54,
          ),
          Row(
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
        ],
      ),
    );
  }

  Widget _buildBodySection() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              controller: _textEditingController,
              maxLines: 16,
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
            _buildRowAction(
                const Icon(
                  Icons.image,
                  color: Colors.green,
                ),
                'รูปภาพ/วิดีโอ', () {
              // TODO(taati): add image
            }),
            _buildRowAction(
                const Icon(
                  Icons.edit_location_sharp,
                  color: Colors.red,
                ),
                'เช็คอิน', () {
              // TODO(taati): check in
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
        _buildBodySection(),
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
