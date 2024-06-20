import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

// Class untuk halaman utama yang menggunakan MaterialApp
class ModuleEducationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
          VideoListScreen(), // Menetapkan VideoListScreen sebagai halaman utama
    );
  }
}

// Class untuk menampilkan daftar video dalam bentuk list
class VideoListScreen extends StatelessWidget {
  // Daftar video yang akan ditampilkan
  final List<Map<String, String>> videos = [
    {
      'title': 'Saham 101',
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
      'title': 'Behavior and Traditional Finance',
      'category': 'Personal Finance',
      'path': 'videos/modul3.mp4',
      'thumbnail': 'images/modul3.jpg'
    },
    {
      'title': 'Behavior and Traditional Finance',
      'category': 'Personal Finance',
      'path': 'videos/modul4.mp4',
      'thumbnail': 'images/modul4.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modul Finansial'), // Judul AppBar
      ),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          // Membuat VideoCard untuk setiap video dalam daftar
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

// Widget untuk menampilkan detail kartu video
class VideoCard extends StatelessWidget {
  final String title; // Judul video
  final String category; // Kategori video
  final String videoPath; // Path video
  final String thumbnailPath; // Path thumbnail video

  VideoCard({
    required this.title,
    required this.category,
    required this.videoPath,
    required this.thumbnailPath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white, // Warna latar belakang kartu
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)), // Bentuk kartu
      margin: EdgeInsets.all(10.0), // Margin dari kartu
      elevation: 5, // Tinggi elevasi kartu
      child: Stack(
        children: [
          // Stack untuk menumpuk thumbnail dan overlay
          ClipRRect(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(10.0)), // Melengkungkan sudut atas
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
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10.0)), // Melengkungkan sudut atas
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
                      // Judul video
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      // Kategori video
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
                // Tombol untuk memutar video
                ButtonBar(
                  alignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(Icons.play_arrow),
                      color: Colors.white,
                      onPressed: () {
                        // Navigasi ke halaman pemutar video ketika tombol ditekan
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

// Halaman untuk memutar video
class VideoPlayerScreen extends StatefulWidget {
  final String videoPath; // Path video yang akan diputar

  VideoPlayerScreen({required this.videoPath});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller; // Kontroller untuk pemutar video

  @override
  void initState() {
    super.initState();
    // Inisialisasi VideoPlayerController dengan video dari asset
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..setLooping(true) // Mengatur agar video diulang-ulang
      ..initialize().then((_) {
        setState(() {});
        _controller.play(); // Memulai pemutaran video
      });
    _controller.addListener(() {
      setState(() {}); // Memperbarui state untuk merefleksikan posisi saat ini
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Membebaskan sumber daya VideoPlayerController
    super.dispose();
  }

  // Fungsi untuk memutar mundur video sebanyak 15 detik
  void _rewind() {
    final newPosition = _controller.value.position - Duration(seconds: 15);
    _controller
        .seekTo(newPosition >= Duration.zero ? newPosition : Duration.zero);
  }

  // Fungsi untuk maju mundur video sebanyak 15 detik
  void _forward() {
    final newPosition = _controller.value.position + Duration(seconds: 15);
    final endPosition = _controller.value.duration;
    _controller.seekTo(newPosition <= endPosition ? newPosition : endPosition);
  }

  // Fungsi untuk mengubah durasi menjadi format menit:detik
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modul Finansial'), // Judul AppBar
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller), // Memainkan video
                  )
                : CircularProgressIndicator(), // Indikator progress saat video sedang dimuat
          ),
          VideoProgressIndicator(_controller,
              allowScrubbing: true), // Indikator progress video
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.replay_10), // Tombol mundur 10 detik
                onPressed: _rewind,
              ),
              IconButton(
                icon: Icon(_controller.value.isPlaying
                    ? Icons
                        .pause // Tombol jeda jika video sedang diputar atau tombol putar jika tidak
                    : Icons.play_arrow),
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.forward_10), // Tombol maju 10 detik
                onPressed: _forward,
              ),
            ],
          ),
          Text(
            '${_formatDuration(_controller.value.position)} / ${_formatDuration(_controller.value.duration)}',
          ), // Durasi video yang sedang diputar
        ],
      ),
    );
  }
}
