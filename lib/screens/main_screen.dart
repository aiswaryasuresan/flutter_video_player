import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_video_player/screens/profile/profile_page.dart';
import 'package:video_player/video_player.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;
  int _currentVideoIndex = 0;
  final List<String> _videoUrls = [
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    'https://www.shutterstock.com/shutterstock/videos/1097895557/preview/stock-footage--seconds-timer-animation-with-split-elapsed-circle-effect-in-green-screen-background.webm',
  ];

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      _videoUrls[_currentVideoIndex],
    );
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: true,
      looping: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 200.0,
                      enlargeCenterPage: false,
                      autoPlay: false,
                      enableInfiniteScroll: false,
                    ),
                    items: _videoUrls.map((url) {
                      return VideoPlayerItem(url: url);
                    }).toList(),
                  ),
                ),
                //Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Implement download functionality
                    },
                    child: const Text(
                      'Download Video',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          Positioned(
  top: 0,
  left: 16,
  child: PopupMenuButton<String>(
    icon: const Icon(Icons.menu),
    onSelected: (value) {
      // Handle menu item selection here
      print('Selected: $value');
      // Navigate to profile page if 'Profile' is selected
      if (value == 'Profile') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return ProfilePage();
          }),
        );
      }
      if (value == 'Settings') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return ProfilePage();
          }),
        );
      }
    },
    itemBuilder: (BuildContext context) {
      return {'Login', 'Profile', 'Settings'}.map((String choice) {
        return PopupMenuItem<String>(
          value: choice,
          child: Text(choice),
        );
      }).toList();
    },
  ),
),

            Positioned(
              top: 0,
              right: 16,
              child: IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () {
                  // Handle user icon tap
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerItem extends StatelessWidget {
  final String url;

  const VideoPlayerItem({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: ChewieController(
        videoPlayerController: VideoPlayerController.network(
          url,
        ),
        autoPlay: false,
        looping: false,
      ),
    );
  }
}
