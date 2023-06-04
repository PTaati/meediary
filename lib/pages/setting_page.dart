import 'package:flutter/material.dart';
import 'package:meediary/constants/routes.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  Widget _buildRow(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(){
    return  const Divider(
      height: 2,
      color: Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ตั้งค่า'),
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildDivider(),
              _buildRow('ตั้งรหัสผ่าน', () {
                Navigator.of(context).pushNamed(RouteNames.setPasswordPage);
              }),
              _buildDivider(),
              _buildRow('ลบข้อมูลทั้งหมด', () {
                // TODO(taati): delete all value
              }),
            ],
          ),
        ),
      ),
    );
  }
}
