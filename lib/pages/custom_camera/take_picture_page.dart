import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TakePicturePage extends StatefulWidget {
  const TakePicturePage({super.key});

  @override
  State<TakePicturePage> createState() => _TakePicturePageState();
}

class _TakePicturePageState extends State<TakePicturePage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late List<CameraDescription> _cameras;
  final ValueNotifier<double> _zoomLevel = ValueNotifier(1);
  late double _maxZoomLevel;
  late double _minZoomLevel;
  late Future _initZoomDetailFuture;

  @override
  void initState() {
    super.initState();

    _cameras = Provider.of<List<CameraDescription>>(context, listen: false);
    _controller = CameraController(
      _cameras.first,
      ResolutionPreset.max,
      enableAudio: false,
    );

    _zoomLevel.addListener(() async {
      await _initZoomDetailFuture;
      final zoomLevel = _zoomLevel.value;
      _controller.setZoomLevel(zoomLevel);
    });

    _initializeControllerFuture = _controller.initialize();
    _initZoomDetailFuture = _initZoomDetail();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initZoomDetail() async {
    await _initializeControllerFuture;
    _maxZoomLevel = await _controller.getMaxZoomLevel();
    _minZoomLevel = await _controller.getMinZoomLevel();
  }

  Widget _buildZoomSlider() {
    return SafeArea(
      child: FutureBuilder(
        future: _initZoomDetailFuture,
        builder: (buildZoomSliderFutureContext, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Align(
              alignment: Alignment.topRight,
              child: ValueListenableBuilder<double>(
                valueListenable: _zoomLevel,
                builder: (context, zoomLevel, child) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 6,
                      ),
                      SizedBox(
                        width: 60,
                        height: MediaQuery.of(context).size.height / 2,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Slider(
                            min: _minZoomLevel,
                            max: _maxZoomLevel,
                            activeColor: Colors.white12,
                            inactiveColor: Colors.black12,
                            value: zoomLevel,
                            onChanged: (double value) {
                              _zoomLevel.value = value;
                            },
                          ),
                        ),
                      ),
                      Text(
                        '${zoomLevel.round()}x',
                        style: const TextStyle(
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildCameraView() {
    return Center(
      child: CameraPreview(
        _controller,
        child: const Icon(
          Icons.filter_center_focus,
          color: Colors.black12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                _buildCameraView(),
                _buildZoomSlider(),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: IconButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();

            if (!context.mounted) return;

            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }
        },
        icon: const Icon(
          Icons.camera,
          color: Colors.white,
          size: 44,
        ),
      ),
    );
  }
}

/// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          Center(child: InteractiveViewer(child: Image.file(File(imagePath)))),
    );
  }
}
