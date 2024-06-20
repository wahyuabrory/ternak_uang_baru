  import 'package:flutter/material.dart';
  import 'package:video_player/video_player.dart';

  class ModuleEducationPage extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Video App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: VideoListScreen(),
      );
    }
  }

  class VideoListScreen extends StatelessWidget {
    final List<Map<String, String>> videos = [
      {
        'title': 'Sample Video 1',
        'category': 'Saham',
        'path': 'videos/modul1.mp4',
        'thumbnail': 'images/modul1.jpg'
      },
      {
        'title': 'Banking Finance',
        'category': 'Saham',
        'path': 'videos/modul2.mp4',
        'thumbnail': 'images/modul2.jpg'
      },
      {
        'title': 'Behavior and Tradional Finance',
        'category': 'Personal Finance',
        'path': 'videos/modul2.mp4',
        'thumbnail': 'images/modul3.jpg'
      },
      {
        'title': 'Behavior and Tradional Finance',
        'category': 'Personal Finance',
        'path': 'videos/modul4.mp4',
        'thumbnail': 'images/modul4.jpg'
      },
    ];

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Modul Finansial'),
        ),
        body: ListView.builder(
          itemCount: videos.length,
          itemBuilder: (context, index) {
            return VideoCard(
              title: videos[index]['title']!,
              category: videos[index]['category']!,
              videoPath: videos[index]['path']!,
              thumbnailPath: videos[index]['thumbnail']!,
            );
          },
        ),
      );
    }
  }

  class VideoCard extends StatelessWidget {
    final String title;
    final String category;
    final String videoPath;
    final String thumbnailPath;

    VideoCard({
      required this.title,
      required this.category,
      required this.videoPath,
      required this.thumbnailPath,
    });

    @override
    Widget build(BuildContext context) {
      return Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: EdgeInsets.all(10.0),
        elevation: 5,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
              child: Image.asset(
                thumbnailPath,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          category,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[300],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(Icons.play_arrow),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  VideoPlayerScreen(videoPath: videoPath),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  class VideoPlayerScreen extends StatefulWidget {
    final String videoPath;

    VideoPlayerScreen({required this.videoPath});

    @override
    _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
  }

  class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
    late VideoPlayerController _controller;

    @override
    void initState() {
      super.initState();
      _controller = VideoPlayerController.asset(widget.videoPath)
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
