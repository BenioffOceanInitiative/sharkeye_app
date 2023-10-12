import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'package:sharkeye/results_page.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class InferencePage extends StatefulWidget {
  const InferencePage({
    super.key,
    required this.thumbnails,
  });

  final List<File> thumbnails;

  @override
  State<InferencePage> createState() => _InferencePageState();
}

class _InferencePageState extends State<InferencePage> {
  late ModelObjectDetection objectDetectionModel;
  late List<ResultObjectDetection> recognitions;
  late List<Widget> boundingBoxImages;
  int currentIndex = 0;
  int maxDetections = 0;

  @override
  void initState() {
    super.initState();

    recognitions = List.empty(growable: true);
    boundingBoxImages = List.empty(growable: true);
    currentIndex = 0;
    maxDetections = 0;
    loadModel().then(
      (_) => processImage(
        widget.thumbnails[currentIndex],
      ),
    );
  }

  Future<void> loadModel() async {
    try {
      objectDetectionModel = await PytorchLite.loadObjectDetectionModel(
        "assets/models/speed_test_640.torchscript",
        1,
        640,
        640,
        labelPath: "assets/labels/labels.txt",
        objectDetectionModelType: ObjectDetectionModelType.yolov5,
      );
      print('Successfully Loaded Model');
    } catch (e) {
      print("Load Model Error: $e");
    }
  }

  void processImage(File thumbnail) async {
    int predictionTimeStart = DateTime.now().millisecondsSinceEpoch;
    recognitions = await objectDetectionModel.getImagePrediction(
      thumbnail.readAsBytesSync(),
      minimumScore: 0.75,
    );
    maxDetections = max(maxDetections, recognitions.length);

    int predictionTime =
        DateTime.now().millisecondsSinceEpoch - predictionTimeStart;
    print('Prediction time: $predictionTime ms');

    boundingBoxImages.add(
      objectDetectionModel.renderBoxesOnImage(thumbnail, recognitions),
    );

    if (currentIndex < widget.thumbnails.length - 1) {
      setState(() {
        currentIndex++;
      });
      processImage(widget.thumbnails[currentIndex]);
    } else {
      print('All images processed.');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResultsPage(
              boundingBoxImages: boundingBoxImages, detections: maxDetections),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inference'),
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.height * .25,
            height: MediaQuery.of(context).size.height * .25,
            child: CircularStepProgressIndicator(
              currentStep: currentIndex,
              totalSteps: widget.thumbnails.length,
              selectedColor: const Color(0xFF2596BE),
              unselectedColor: Colors.grey,
              selectedStepSize: 15,
              roundedCap: (_, __) => true,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Lottie.asset(
                  'assets/animations/shark_thinking.json',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
