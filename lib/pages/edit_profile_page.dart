import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meediary/data_models/user.dart';
import 'package:meediary/objectbox.g.dart';
import 'package:meediary/services/object_box.dart';
import 'package:meediary/utils/file_utils.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final ImagePicker picker = ImagePicker();
  XFile? xFile;
  late TextEditingController _nameTextEditingController;
  late TextEditingController _noteTextEditingController;
  late Box<User> userBox;
  late User user;

  @override
  void initState() {
    super.initState();
    final objectBox = Provider.of<ObjectBox>(context, listen: false);
    userBox = objectBox.store.box<User>();
    user = Provider.of<User>(context, listen: false);

    _nameTextEditingController = TextEditingController(text: user.name);
    _noteTextEditingController = TextEditingController(text: user.note);
  }

  Widget _buildEditProfile() {
    return GestureDetector(
      onTap: () async {
        final XFile? image = await picker.pickImage(source: ImageSource.camera);
        if (!mounted) {
          return;
        }
        setState(() {
          xFile = image;
        });
      },
      child: Stack(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey,
            foregroundImage: xFile != null
                ? Image.file(File(xFile!.path)).image
                : user.avatarPath != null
                    ? Image.file(File(user.avatarPath!)).image
                    : null,
            child: const Icon(
              Icons.person,
              size: 100,
            ),
          ),
          const Positioned(
            bottom: 0,
            right: 0,
            child: Icon(
              Icons.change_circle,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditInformation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          TextFormField(
            controller: _nameTextEditingController,
            decoration: const InputDecoration(
              hintText: 'พิมพ์ชื่อของคุณ',
              labelText: 'ชื่อที่แสดง',
              labelStyle: TextStyle(color: Colors.white),
            ),
          ),
          TextFormField(
            controller: _noteTextEditingController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'พิมพ์ข้อความ',
              labelText: 'ข้อความ',
              labelStyle: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: ElevatedButton(
          onPressed: () async {
            user.name = _nameTextEditingController.text;
            user.note = _noteTextEditingController.text;

            if (xFile != null) {
              final imagePath = await saveFileInApp(xFile!);
              user.avatarPath = imagePath;
            }

            userBox.put(user);

            // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
            user.notifyListeners();

            if (!mounted) {
              return;
            }

            Navigator.of(context).pop();
          },
          child: const Text('บันทึก')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildEditProfile(),
          _buildEditInformation(),
          _buildSaveButton(),
        ],
      ),
    );
  }
}
