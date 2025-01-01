import 'dart:io';
  
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:music_speed_changer/pages/history_page.dart';
import 'package:music_speed_changer/pages/play_page.dart';
import 'package:music_speed_changer/pages/settings_page.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  File? selectedFile; // To store the uploaded MP3 file
  final TextEditingController secondsController = TextEditingController();

  Future<void> pickMp3File() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      Directory appStorage = await getApplicationDocumentsDirectory();
      String newPath = '${appStorage.path}/${file.uri.pathSegments.last}';
      File storedFile = await file.copy(newPath);

      setState(() {
        selectedFile = storedFile;
      });
    }
  }

  void submitForm() {
    if (selectedFile == null || secondsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('Please upload an MP3 file and enter a duration.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PlayPage()),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Music Speed Changer"),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: pickMp3File,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue[400],
                minimumSize: const Size(80, 55),
              ),
              child: const Text('Upload MP3 File', style: 
              TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 18
              )),
            ),
            const SizedBox(height: 16),
            if (selectedFile != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text('Selected File: ${selectedFile!.path.split('/').last}'),
              ),
            TextField(
              controller: secondsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter seconds per cropped part',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue[400],
              ),
              child: const Text('Sumbit', style: 
              TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 18
              )),
            ),
          ],
        ),
      ),
       bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HistoryPage()),
            );
          }
        },
      ),

    );
  }
}