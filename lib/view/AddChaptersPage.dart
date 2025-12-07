import 'dart:ui';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/course_model.dart';

class AddChaptersPage extends StatefulWidget {
  final Course course;

  const AddChaptersPage({super.key, required this.course});

  @override
  State<AddChaptersPage> createState() => _AddChaptersPageState();
}

class _AddChaptersPageState extends State<AddChaptersPage> {
  final TextEditingController chapterCtrl = TextEditingController();
  String selectedVideo = "assets/videos/1206.mp4";

  String? writtenContent;

  // CREATE PDF USING ADMIN INPUT ON DEVICE
  Future<String> generatePdfFromText(String chapterName, String content) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) =>
            pw.Text(content, style: const pw.TextStyle(fontSize: 18)),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final filePath = "${dir.path}/$chapterName.pdf";

    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    return filePath;
  }

  // OPEN WHITE SCREEN EDITOR
  void openEditor() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfEditorPage(),
      ),
    );

    if (result != null) {
      setState(() => writtenContent = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7F7CFF), Color(0xFFA77BFF), Color(0xFFD77BFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Chapitres - ${widget.course.title}",
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // CHAPTER NAME INPUT
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.25)),
                      ),
                      child: TextField(
                        controller: chapterCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: "Nom du chapitre",
                          labelStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // WRITE PDF CONTENT BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: openEditor,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.25),
                      foregroundColor: Colors.white,
                    ),
                    child: Text(writtenContent == null
                        ? "Écrire le contenu du PDF"
                        : "Contenu écrit ✔"),
                  ),
                ),

                const SizedBox(height: 20),

                // ADD CHAPTER BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      final chapterName = chapterCtrl.text.trim();
                      if (chapterName.isEmpty || writtenContent == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                              Text("Veuillez écrire un contenu et remplir le titre.")),
                        );
                        return;
                      }

                      // CREATE LOCAL PDF
                      final pdfPath =
                      await generatePdfFromText(chapterName, writtenContent!);

                      // SAVE TO FIRESTORE (LOCAL ONLY)
                      await FirebaseFirestore.instance
                          .collection('courses')
                          .doc(widget.course.id)
                          .collection('chapters')
                          .add({
                        'name': chapterName,
                        'videoUrl': selectedVideo,
                        'pdfPath': pdfPath,        // LOCAL FILE ONLY
                        'createdAt': Timestamp.now(),
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Chapitre ajouté avec PDF local !")),
                      );

                      chapterCtrl.clear();
                      setState(() => writtenContent = null);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.25),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Ajouter le chapitre",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ================================================
// WHITE SCREEN EDITOR PAGE
// ================================================
class PdfEditorPage extends StatefulWidget {
  @override
  State<PdfEditorPage> createState() => _PdfEditorPageState();
}

class _PdfEditorPageState extends State<PdfEditorPage> {
  final TextEditingController textCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Éditer le contenu du PDF"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, textCtrl.text.trim());
            },
            child: const Text("Enregistrer", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: textCtrl,
          maxLines: null,
          expands: true,
          decoration: const InputDecoration(
            hintText: "Écris ton contenu ici...",
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
