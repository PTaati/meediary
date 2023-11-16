import 'package:flutter/material.dart';
import 'package:meediary/constants/routes.dart';
import 'package:meediary/services/object_box.dart';
import 'package:meediary/services/snackbar_service.dart';
import 'package:restart_app/restart_app.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  Widget _buildRow(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
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

  Widget _buildDivider() {
    return const Divider(
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
              _buildRow('ลบข้อมูลทั้งหมด', () async {
                await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('ยืนยันการลบข้อมูลทั้งหมด'),
                        content: const Text(
                            'หากลบแล้วจะไม่สามารถกู้คืนข้อมูลได้!!!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('ไม่ลบ'),
                          ),
                          TextButton(
                            onPressed: () {
                              ObjectBox.delete().then((_) async {
                                SnackBarService.showSnackBar(
                                  'ลบข้อมูลทั้งหมดเรียบร้อยแล้ว',
                                  context,
                                );
                                Navigator.of(context).pop();
                                await Restart.restartApp();
                              });
                            },
                            child: const Text('ลบ'),
                          ),
                        ],
                      );
                    });
              }),
            ],
          ),
        ),
      ),
    );
  }
}
