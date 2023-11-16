import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class SetPasswordPage extends StatefulWidget {
  const SetPasswordPage({super.key});

  @override
  State<SetPasswordPage> createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<SetPasswordPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var animationPath = 'assets/3645-7621-remix-of-login-machine.riv';
  late SMITrigger failTrigger, successTrigger;
  late SMIBool isChecking, isHandsUp;
  Artboard? artboard;
  late StateMachineController stateMachineController;

  @override
  void initState() {
    super.initState();
    initArtboard();
  }

  void initArtboard() {
    rootBundle.load(animationPath).then((value) {
      final file = RiveFile.import(value);
      final art = file.mainArtboard;
      stateMachineController =
          StateMachineController.fromArtboard(art, "Login Machine")!;

      art.addController(stateMachineController);
      for (var element in stateMachineController.inputs) {
        if (element.name == 'isChecking') {
          isChecking = element as SMIBool;
        }
        if (element.name == 'isHandsUp') {
          isHandsUp = element as SMIBool;
        }
        if (element.name == 'trigSuccess') {
          successTrigger = element as SMITrigger;
        }
        if (element.name == 'trigFail') {
          failTrigger = element as SMITrigger;
        }
      }
      isChecking.change(false);
      setState(() {
        artboard = art;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (artboard != null)
            SizedBox(
              width: 400,
              height: 270,
              child: Rive(
                artboard: artboard!,
                fit: BoxFit.contain,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onTap: () {
                isHandsUp.change(true);
              },
              onTapOutside: (v) {
                isHandsUp.change(false);
              },
              onFieldSubmitted: (v) {
                isHandsUp.change(false);
              },
              onChanged: (v){
                isHandsUp.change(true);
              },
              obscureText: true,
              controller: passwordController,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          // ElevatedButton(onPressed: () async {
          //   isHandsUp.change(false);
          //   successTrigger.fire();
          // }, child: Text('Save')),
          // TextButton(
          //   onPressed: () {
          //     isHandsUp.change(true);
          //   },
          //   child: Text('ปิดตา'),
          // ),
          // TextButton(
          //   onPressed: () {
          //     isHandsUp.change(false);
          //   },
          //   child: Text('เปิดตา'),
          // ),
          // TextButton(
          //   onPressed: () {
          //     isHandsUp.change(false);
          //     failTrigger.advance();
          //     successTrigger.fire();
          //   },
          //   child: Text('ดีใจ'),
          // ),
          // TextButton(
          //   onPressed: () {
          //     isHandsUp.change(false);
          //     successTrigger.advance();
          //     failTrigger.fire();
          //   },
          //   child: Text('เสียดีใจ'),
          // ),
        ],
      )),
    );
  }
}
