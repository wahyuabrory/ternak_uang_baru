import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'EducationModule.dart';

class ModuleEducationPage extends StatelessWidget {
  final List<EducationModule> modules = [
    EducationModule(
      title: 'Video 1',
      description: 'This is the first video description.',
      videoUrl: 'https://www.example.com/video1.mp4',
      thumbnail: 'assets/thumbnails/video1.png',
    ),
    EducationModule(
      title: 'Video 2',
      description: 'This is the second video description.',
      videoUrl: 'https://www.example.com/video2.mp4',
      thumbnail: 'assets/thumbnails/video2.png',
    ),
    // Add more video modules here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: modules.length,
        itemBuilder: (context, index) {
          final module = modules[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Image.asset(
                module.thumbnail,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              title: Text(module.title),
              subtitle: Text(module.description),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          VideoPlayerScreen(videoUrl: module.videoUrl),
                    ),
                  );
                },
                child: Text('Play'),
              ),
            ),
          );
        },
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  VideoPlayerScreen({required this.videoUrl});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
