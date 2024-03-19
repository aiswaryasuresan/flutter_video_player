import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_player/app/common/storage/video.dart';
import 'package:flutter_video_player/app/data/models/model_s3_video.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class HomeController extends GetxController {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  List<ModelS3Video> videos = [];
  bool isLoading = true;
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  int activeVideoIndex = 0;

  ModelS3Video get activeVideo => videos[activeVideoIndex];
  bool isPreparingVideo = true;

  bool get isDownloaded => activeVideo.isDownloaded;

  String playingPath = '';

  _setLoadingState(bool s) {
    isLoading = s;
    update();
  }

  @override
  void onInit() {
    _fetchVideoLists();
    super.onInit();
  }

  void _fetchVideoLists() async {
    QuerySnapshot videoDocs = await _fireStore.collection("videos").get();
    for (var doc in videoDocs.docs) {
      Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
      String url = docData['url'].toString();
      bool isDownloaded = await VideoStorage.isDownloaded(url);
      videos.add(ModelS3Video(id: doc.id, url: url, isDownloaded: isDownloaded));
    }
    if (videos.isNotEmpty) {
      _initVideoPlayer();
    } else {
      Get.snackbar('No videos', 'No videos uploaded yet'); /**/
      _setLoadingState(false);
    }
  }

  _initVideoPlayer() async {
    String url = activeVideo.url;
    if (activeVideo.isDownloaded) {
      printInfo(info: "Marked as downloaded");
      File? videoFile = await VideoStorage.getLocalVideo(activeVideo);
      if (videoFile != null) {
        playingPath = videoFile.path;
        printInfo(info: "Decrypted local file");
        videoPlayerController = VideoPlayerController.file(videoFile)
          ..initialize().then((_) {
            _setChewieController();
          });
        videoPlayerController?.addListener(_videoPreparingListener);
        return;
      } else {
        printInfo(info: "Unable to find or decrypt local file");
      }
    }

    printInfo(info: "Loading network file");
    playingPath = url;
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) {
        _setChewieController();
      });
    videoPlayerController?.addListener(_videoPreparingListener);
  }

  _videoPreparingListener() {
    if (videoPlayerController?.value.isInitialized == true && isPreparingVideo) {
      isPreparingVideo = false;
      update();
    }
  }

  void _setChewieController() {
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController!,
      autoPlay: false,
      looping: true,
      additionalOptions: (BuildContext context) => [
        OptionItem(
          onTap: _fastForward,
          iconData: Icons.fast_forward,
          title: 'Fast Forward',
        ),
        OptionItem(
          onTap: _rewind,
          iconData: Icons.fast_rewind,
          title: 'Rewind',
        ),
        OptionItem(
          onTap: previousVideo,
          iconData: Icons.skip_previous,
          title: 'Previous',
        ),
        OptionItem(
          onTap: nextVideo,
          iconData: Icons.skip_next,
          title: 'Next',
        ),
      ],
    );
    _setLoadingState(false);
  }

  final Duration _xDuration = const Duration(seconds: 10);

  void _fastForward() {
    final currentPosition = videoPlayerController!.value.position;
    final duration = videoPlayerController!.value.duration;
    if (currentPosition + _xDuration < duration) {
      if (currentPosition + _xDuration > Duration.zero) {
        videoPlayerController!.seekTo(currentPosition + _xDuration);
      } else {
        videoPlayerController!.seekTo(Duration.zero);
      }
    } else {
      videoPlayerController!.seekTo(duration);
    }
  }

  void _rewind() {
    final currentPosition = videoPlayerController!.value.position;
    if (currentPosition - _xDuration > Duration.zero) {
      videoPlayerController!.seekTo(currentPosition - _xDuration);
    } else {
      videoPlayerController!.seekTo(Duration.zero);
    }
  }

  _clearVideoControllers() {
    isPreparingVideo = true;
    videoPlayerController?.removeListener(_videoPreparingListener);
    videoPlayerController?.pause();
    chewieController?.pause();
    videoPlayerController?.dispose();
    chewieController?.dispose();
    update();
  }

  previousVideo() {
    _clearVideoControllers();
    if (activeVideoIndex == 0) {
      activeVideoIndex = videos.length - 1;
    } else {
      activeVideoIndex = activeVideoIndex - 1;
    }
    _initVideoPlayer();
  }

  nextVideo() {
    _clearVideoControllers();
    if (activeVideoIndex < videos.length - 1) {
      activeVideoIndex = activeVideoIndex + 1;
    } else {
      activeVideoIndex = 0;
    }
    _initVideoPlayer();
  }

  downloadVideo() async {
    if (!activeVideo.isDownloaded) {
      _setLoadingState(true);
      Get.snackbar('Downloading', 'Please wait, video is being downloaded');
      await VideoStorage.downloadAndEncryptVideo(activeVideo);
      Get.snackbar('Success', 'Video has been downloaded success fully');
      videos[activeVideoIndex].isDownloaded = true;
      _clearVideoControllers();
      _initVideoPlayer();
      _setLoadingState(false);
    }
  }
}
