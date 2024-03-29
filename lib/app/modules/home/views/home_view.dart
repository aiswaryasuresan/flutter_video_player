import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_player/app/modules/home/controllers/home_controller.dart';
import 'package:flutter_video_player/app/modules/home/views/button_widget.dart';
import 'package:flutter_video_player/app/modules/home/views/home_drawer.dart';
import 'package:flutter_video_player/app/modules/widgets/loading_widget.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Videos'),
        centerTitle: true,
      ),
      drawer: const HomeDrawer(),
      body: GetBuilder<HomeController>(builder: (homeController) {
        return homeController.isLoading
            ? const LoadingWidget()
            : Column(
                children: [
                  Container(
                    color: Colors.black,
                    height: context.width / 2,
                    child: homeController.videoPlayerController == null || homeController.isPreparingVideo
                        ? const LoadingWidget()
                        : Chewie(
                            controller: homeController.chewieController!,
                          ),
                  ),
                  const Divider(),
                  Container(
                    color: Colors.black38,
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        VideoRoundButton(
                          onPressed: () => homeController.nextVideo(),
                          icon: Icons.skip_previous,
                        ),
                        if (homeController.isDownloaded) const ElevatedButton(onPressed: null, child: Text("Downloaded")),
                        if (!homeController.isDownloaded) ElevatedButton(onPressed: () => homeController.downloadVideo(), child: const Text("Download")),
                        VideoRoundButton(
                          onPressed: () => homeController.previousVideo(),
                          icon: Icons.skip_next,
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  Text("Playing ${homeController.activeVideoIndex}/${homeController.videos.length}"),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: homeController.playingPath));
                    },
                    child: Text(
                      "Playing Path: ${homeController.playingPath}",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
      }),
    );
  }
}
