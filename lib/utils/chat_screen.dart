import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart'; // Import paket untuk integrasi dengan model generative AI dari Google.
import 'package:intl/intl.dart'; // Import paket untuk formatting tanggal dan waktu.
import 'package:flutter_markdown/flutter_markdown.dart'; // Import paket untuk menampilkan teks dalam format Markdown.

// Kelas utama ChatScreen yang merupakan StatefulWidget.
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

// State dari ChatScreen, menggunakan mixin TickerProviderStateMixin untuk mengatur animasi.
class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _userInput =
      TextEditingController(); // Controller untuk input pengguna.
  final GlobalKey<AnimatedListState> _listKey =
      GlobalKey<AnimatedListState>(); // Key untuk mengakses AnimatedList.
  final ScrollController _scrollController =
      ScrollController(); // Controller untuk mengatur scroll.

  // API key untuk mengakses model generative AI dari Google.
  static const apiKey = "AIzaSyCXgodaVJUHVOePhVbQTbshDa8WuI5Ffus";
  final model = GenerativeModel(
      model: 'gemini-1.5-pro-latest',
      apiKey: apiKey); // Objek model generative AI.

  final List<Message> _messages = []; // List untuk menyimpan pesan-pesan.

  // Method untuk mengirim pesan pengguna.
  Future<void> sendMessage() async {
    final message = _userInput.text; // Ambil teks dari input pengguna.

    if (message.isEmpty) return; // Jika pesan kosong, tidak melakukan apa-apa.

    final userMessage = Message(
      // Buat objek pesan dari pengguna.
      isUser: true,
      message: message,
      date: DateTime.now(),
    );
    _addMessage(userMessage); // Tambahkan pesan pengguna ke daftar.

    _userInput.clear(); // Bersihkan input pengguna setelah mengirim pesan.

    final content = [
      Content.text(message)
    ]; // Konten yang akan digunakan untuk model generative AI.

    try {
      final response = await model.generateContent(
          content); // Panggil model untuk menghasilkan balasan.
      final botMessage = Message(
        // Buat objek pesan dari bot berdasarkan respons model.
        isUser: false,
        message: response.text ?? "No response",
        date: DateTime.now(),
      );
      _addMessage(botMessage); // Tambahkan pesan bot ke daftar.
    } catch (e) {
      final errorMessage = Message(
        // Tangkap error jika terjadi kesalahan.
        isUser: false,
        message: "Error: $e",
        date: DateTime.now(),
      );
      _addMessage(errorMessage); // Tambahkan pesan error ke daftar.
    }
  }

  // Method untuk menambahkan pesan ke daftar dan melakukan animasi.
  void _addMessage(Message message) {
    _messages.add(message); // Tambahkan pesan ke list.
    _listKey.currentState
        ?.insertItem(_messages.length - 1); // Insert pesan ke AnimatedList.
    _scrollToBottom(); // Scroll ke bagian bawah layar.
  }

  // Method untuk mengatur scroll ke posisi paling bawah.
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    });
  }

  // Build method dari State yang mengembalikan widget Scaffold sebagai tampilan utama.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 52, 127, 255), Colors.white],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: AnimatedList(
                // AnimatedList untuk menampilkan daftar pesan dengan animasi.
                key: _listKey,
                controller: _scrollController,
                initialItemCount: _messages.length,
                itemBuilder: (context, index, animation) {
                  final message = _messages[index];
                  return SizeTransition(
                    // Animasi ukuran transisi untuk setiap pesan.
                    sizeFactor: animation,
                    child: Messages(
                      // Widget Messages untuk menampilkan pesan.
                      isUser: message.isUser,
                      message: message.message,
                      date: DateFormat('HH:mm').format(message.date),
                      animationDuration: message.isUser
                          ? const Duration(milliseconds: 0)
                          : const Duration(milliseconds: 100),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 15,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              // Input untuk pengguna mengirim pesan.
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              controller: _userInput,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Ask anything',
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                              ),
                              onFieldSubmitted: (value) => sendMessage(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    // Tombol ikon untuk mengirim pesan.
                    padding: const EdgeInsets.all(12),
                    iconSize: 30,
                    color: Colors.blueAccent,
                    onPressed: sendMessage,
                    icon: const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Kelas Message untuk merepresentasikan pesan yang dikirim atau diterima.
class Message {
  final bool
      isUser; // Boolean untuk menandai apakah pesan dari pengguna atau bukan.
  final String message; // Isi dari pesan.
  final DateTime date; // Waktu ketika pesan dikirim.

  Message({required this.isUser, required this.message, required this.date});
}

// Kelas Messages yang merupakan StatefulWidget untuk menampilkan pesan dengan animasi.
class Messages extends StatefulWidget {
  final bool
      isUser; // Boolean untuk menandai apakah pesan dari pengguna atau bukan.
  final String message; // Isi dari pesan.
  final String date; // Waktu ketika pesan dikirim.
  final Duration animationDuration; // Durasi animasi untuk pesan.

  const Messages({
    super.key,
    required this.isUser,
    required this.message,
    required this.date,
    required this.animationDuration,
  });

  @override
  _MessagesState createState() => _MessagesState();
}

// State dari Messages untuk mengatur animasi dan tampilan pesan.
class _MessagesState extends State<Messages>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; // Controller untuk mengatur animasi.
  late Animation<int>
      _charCountAnimation; // Animasi untuk menghitung jumlah karakter dalam pesan.

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _charCountAnimation = IntTween(begin: 0, end: widget.message.length)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear))
      ..addListener(() {
        setState(() {});
      });
    _controller.forward(); // Mulai animasi ketika initState dipanggil.
  }

  @override
  void dispose() {
    _controller.dispose(); // Hentikan animasi dan dispose controller.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5).copyWith(
        left: widget.isUser ? 100 : 10,
        right: widget.isUser ? 10 : 100,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              widget.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: widget.isUser
                    ? const Color.fromARGB(255, 52, 127, 255)
                    : const Color.fromARGB(255, 224, 224, 224),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(22),
                  bottomLeft:
                      widget.isUser ? const Radius.circular(22) : Radius.zero,
                  topRight: const Radius.circular(22),
                  bottomRight:
                      widget.isUser ? Radius.zero : const Radius.circular(22),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: MarkdownBody(
                // Widget untuk menampilkan teks dalam format Markdown.
                data: widget.message.substring(0, _charCountAnimation.value),
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(
                      fontSize: 16,
                      color: widget.isUser ? Colors.white : Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              // Widget untuk menampilkan waktu pengiriman pesan.
              widget.date,
              style: TextStyle(
                  fontSize: 10,
                  color: widget.isUser ? Colors.white70 : Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
