import 'package:flutter/material.dart';

class AddNewPostPage extends StatefulWidget {
  const AddNewPostPage({Key? key}) : super(key: key);

  @override
  State<AddNewPostPage> createState() => _AddNewPostPageState();
}

class _AddNewPostPageState extends State<AddNewPostPage> {
  bool _canSave = false;

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
                    // TODO(taati): implement create new post

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

  Widget _buildBodySection() {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextFormField(
            maxLines: 16,
            cursorColor: Colors.white54,
            decoration: const InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.all(20),
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
        ],
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
