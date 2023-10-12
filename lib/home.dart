import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sharkeye/staging_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<File> videoFiles = List.empty();
  final FilePicker filePicker = FilePicker.platform;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SharkEye',
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      FilePickerResult? results = await filePicker.pickFiles(
                        type: FileType.video,
                        allowMultiple: true,
                        onFileLoading: (FilePickerStatus status) =>
                            print(status),
                        withData: true,
                      );

                      setState(() {
                        isLoading = false;
                      });

                      if (results != null) {
                        List<PlatformFile> files = results.files;
                        videoFiles =
                            files.map((file) => File(file.path!)).toList();

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                StagingPage(videoFiles: videoFiles),
                          ),
                        );
                      }
                    },
                    child: const Text('Select Video(s)'),
                  ),
          ),
        ],
      ),
    );
  }
}
