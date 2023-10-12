import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sharkeye/home.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage(
      {super.key, required this.boundingBoxImages, required this.detections});

  final List<Widget> boundingBoxImages;
  final int detections;

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  PageController pageController = PageController();
  int currentPage = 0;

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      currentPage++;
      if (currentPage >= widget.boundingBoxImages.length) {
        currentPage = 0;
      }
      pageController.animateToPage(
        currentPage,
        duration: const Duration(microseconds: 1),
        curve: Curves.linear,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: PageView.builder(
                          controller: pageController,
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return widget.boundingBoxImages[index];
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Detected: ${widget.detections}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Home()),
                    (route) => false);
              },
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.restart_alt_outlined,
                  size: 36.0,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
