import 'dart:io';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sharkeye/inference_page.dart';
import 'package:sharkeye/loading_action_button.dart';
import 'package:sharkeye/video_preview.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class StagingPage extends StatelessWidget {
  const StagingPage({
    super.key,
    required this.videoFiles,
  });

  final List<File> videoFiles;

  Future<List<File>> generateThumbnails() async {
    final thumbnailPath = await getTemporaryDirectory();
    final thumbnailFiles = <File>[];
    for (int video = 0; video < videoFiles.length; video++) {
      await FFprobeKit.getMediaInformation(videoFiles[video].path)
          .then((session) async {
        final information = session.getMediaInformation();
        if (information == null) {
          // CHECK THE FOLLOWING ATTRIBUTES ON ERROR
          final state =
              FFmpegKitConfig.sessionStateToString(await session.getState());
          final returnCode = await session.getReturnCode();
          final failStackTrace = await session.getFailStackTrace();
          final duration = await session.getDuration();
          final output = await session.getOutput();
          print(
              'No Video Information: $state $returnCode $failStackTrace $duration $output');
        } else {
          int totalDurationInSeconds =
              int.parse(information.getDuration()!.split('.')[0]);

          for (int i = 0; i <= totalDurationInSeconds; i++) {
            final thumbnailFile =
                File('${thumbnailPath.path}/thumbnail_${video}_$i.png');

            final uint8list = await VideoThumbnail.thumbnailData(
              video: videoFiles[video].path,
              imageFormat: ImageFormat.PNG,
              timeMs: i * 1000,
            );

            await thumbnailFile.writeAsBytes(uint8list!);
            thumbnailFiles.add(thumbnailFile);
          }
        }
        return thumbnailFiles;
      });
    }

    return thumbnailFiles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Staging [${videoFiles.length} Files]'),
        actions: [
          LoadingActionButton(
            onPressed: () async {
              List<File> thumbnails = await generateThumbnails();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => InferencePage(
                    thumbnails: thumbnails,
                  ),
                ),
              );
            },
            iconData: Icons.run_circle,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: videoFiles.length,
        itemBuilder: (context, index) {
          return VideoPreview(
            videoFile: videoFiles[index],
          );
        },
      ),
    );
  }
}
