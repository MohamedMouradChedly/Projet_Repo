import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:pdfx/pdfx.dart';
import '../models/course_model.dart';

class CourseChaptersPage extends StatefulWidget {
  final Course course;

  const CourseChaptersPage({super.key, required this.course});

  @override
  State<CourseChaptersPage> createState() => _CourseChaptersPageState();
}

class _CourseChaptersPageState extends State<CourseChaptersPage> {
  VideoPlayerController? _controller;
  String? selectedChapter;

  // Example chapters with video & PDF paths
  final List<Map<String, String?>> chapters = [
    {
      'name': 'Introduction',
      'videoAsset': 'assets/videos/1206.mp4',
      'pdfAsset': 'assets/pdfs/sample.pdf',
    },
    {
      'name': 'Chapter 2',
      'videoAsset': 'assets/videos/1206.mp4',
      'pdfAsset': null,
    },
    {
      'name': 'Chapter 3',
      'videoAsset': null,
      'pdfAsset': 'assets/pdfs/sample.pdf',
    },
  ];

  void selectChapter(Map<String, String?> chapter) {
    setState(() {
      selectedChapter = chapter['name'];

      // Dispose previous video controller
      _controller?.dispose();
      if (chapter['videoAsset'] != null) {
        _controller = VideoPlayerController.asset(chapter['videoAsset']!)
          ..initialize().then((_) {
            setState(() {});
            _controller!.play();
          });
      } else {
        _controller = null;
      }

      // Open PDF if exists
      if (chapter['pdfAsset'] != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PdfViewerPage(pdfAsset: chapter['pdfAsset']!),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.title),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Video Player
            if (_controller != null && _controller!.value.isInitialized)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
              ),

            if (_controller != null)
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                    onPressed: () {
                      setState(() {
                        _controller!.value.isPlaying
                            ? _controller!.pause()
                            : _controller!.play();
                      });
                    },
                  ),
                  const Text("Lecture vidéo"),
                ],
              ),

            const SizedBox(height: 20),
            const Text("Chapitres", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            Expanded(
              child: ListView.separated(
                itemCount: chapters.length,
                separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.grey),
                itemBuilder: (context, index) {
                  final chapter = chapters[index];
                  final isSelected = selectedChapter == chapter['name'];
                  return InkWell(
                    onTap: () => selectChapter(chapter),
                    child: Container(
                      color: isSelected ? Colors.grey[300] : Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                      child: Row(
                        children: [
                          Icon(
                            chapter['videoAsset'] != null ? Icons.play_arrow : Icons.picture_as_pdf,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            chapter['name']!,
                            style: const TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------
// PDF Viewer Page
// ----------------------
class PdfViewerPage extends StatelessWidget {
  final String pdfAsset;

  const PdfViewerPage({super.key, required this.pdfAsset});

  @override
  Widget build(BuildContext context) {
    final PdfControllerPinch pdfController = PdfControllerPinch(
      document: PdfDocument.openAsset(pdfAsset),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("PDF Reader")),
      body: PdfViewPinch(controller: pdfController),
    );
  }
}
