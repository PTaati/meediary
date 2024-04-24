import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
  final _buttonCarouselController = CarouselController();
  final ValueNotifier<int> _filterIndex = ValueNotifier(0);

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

  Widget _getFilterWithIndex(int index) {
    final icons = [
      Icons.filter_center_focus,
      Icons.person,
      Icons.arrow_upward,
    ];
    return Icon(
      icons[index],
      color: Colors.white30,
      size: 100,
    );
  }

  Widget _buildCameraView() {
    return Center(
      child: CameraPreview(
        _controller,
        child: ValueListenableBuilder<int>(
            valueListenable: _filterIndex,
            builder: (context, index, child) {
              return _getFilterWithIndex(index);
            }),
      ),
    );
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(image);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Widget _buildSelectionFilter() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 80,
        width: double.infinity,
        child: Stack(
          children: [
            SizedBox(
              height: 80,
              child: Center(
                child: CarouselSlider(
                  items: [
                    GestureDetector(
                      onTap: _takePicture,
                      child: const Icon(
                        Icons.camera,
                        color: Colors.white,
                        size: 44,
                      ),
                    ),
                    GestureDetector(
                      onTap: _takePicture,
                      child: const Icon(
                        Icons.person_sharp,
                        color: Colors.white,
                        size: 44,
                      ),
                    ),
                    GestureDetector(
                      onTap: _takePicture,
                      child: const Icon(
                        Icons.home_filled,
                        color: Colors.white,
                        size: 44,
                      ),
                    ),
                  ],
                  carouselController: _buttonCarouselController,
                  options: CarouselOptions(
                      autoPlay: false,
                      enlargeCenterPage: true,
                      viewportFraction: 0.25,
                      aspectRatio: 10.0,
                      initialPage: 1,
                      // enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        _filterIndex.value = index;
                      }),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: IgnorePointer(
                ignoring: true,
                child: Container(
                  height: 65,
                  width: 65,
                  margin: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 5,
                      color: Colors.white60,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(32.5),
                    ),
                  ),
                ),
              ),
            )
          ],
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
                _buildSelectionFilter(),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
