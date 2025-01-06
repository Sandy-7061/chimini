import 'dart:typed_data'; // For Uint8List
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Theme/ThemeNotifier.dart'; // For JSON handling

class ImageScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState createState() => _ImageScreenState();
}

class _ImageScreenState extends ConsumerState<ImageScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> chatMessages = []; // Store chat messages
  List<Image> chatImages = []; // Store images to display

  // Function to log the full byte array as a single array
  void logFullByteArray(Uint8List bytes) {
    String byteArrayString = bytes.join(', '); // Convert the byte array to a comma-separated string
    print('Full byte array: [$byteArrayString]');
  }

  // Function to make the API call to the text-to-image API
  Future<void> sendMessage(String message) async {
    if (message.isEmpty) return;

    // Add user message to the chat
    setState(() {
      chatMessages.add(message);
    });

    // Prepare the request body
    final requestBody = json.encode({
      "prompt": message,
    });

    try {
      // Make the API call
      String prompt = _controller.text;
      final response = await http.get(
        Uri.parse('https://image.pollinations.ai/prompt/$prompt')
      );

      // Log the response
      if (response.statusCode == 200) {
        final Uint8List bytes = response.bodyBytes;

        // Log the full byte array as a single array
        logFullByteArray(bytes);

        // Create the Image widget from the byte array (PNG)
        Image image = Image.memory(bytes);

        // Add the image to the chat
        setState(() {
          chatImages.add(image);
        });
      } else {
        print('ImageScreen: Error - Unexpected response: ${response.statusCode}');
      }
    } catch (e) {
      print('ImageScreen: Error in sending message: $e'); // Log error
    }

    // Clear the text field after sending the message
  }
  ThemeMode currenttheme = ThemeMode.light;
  getcurrentTheme(){
    currenttheme = ref.read(themeProvider);
    print("Current Theme is  : $currenttheme");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chimini Imagine"),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Image.asset("assets/images/char_crazy_icon.png"),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              child: (currenttheme == ThemeMode.dark) ? Icon(Icons.dark_mode_rounded) : Icon(Icons.light_mode_rounded),
              onTap: (){
                getcurrentTheme();
                ref.read(themeProvider.notifier).toggletheme();
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Display chat messages and images
          Expanded(
            child: ListView.builder(
              itemCount: chatMessages.length + chatImages.length,
              itemBuilder: (context, index) {
                if (index % 2 == 0) {
                  // Right side for text messages (index is even)
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.blue, // Change color as needed
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          chatMessages[index ~/ 2], // Get the right chat message
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                } else {
                  // Left side for images (index is odd)
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Transform(
                        transform: Matrix4.rotationX(0.1), // 3D effect
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20), // Curved border
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20), // Apply curved border to the image
                            child: chatImages[(index - 1) ~/ 2], // Get the image
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          )
          ,
          // Text input and send button
          Padding(
            padding: const EdgeInsets.only(bottom: 32,top: 16,left: 16,right: 16),
            child: Container(
              decoration: BoxDecoration(
                  color: ref.watch(themeProvider) == ThemeMode.light
                      ? Colors.white70 // Light theme hint color
                      : Color(0xFF1f272a), // Dark theme hint color
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                        color: ref.watch(themeProvider) == ThemeMode.light ? Colors.grey.withOpacity(0.5) : Colors.white.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3)
                    )
                  ]
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(
                        color: ref.watch(themeProvider) == ThemeMode.light
                            ? Colors.black // Light theme text color
                            : Colors.black, // Dark theme text color
                      ),
                      decoration: InputDecoration(
                        hintText: "Chimini Imagine For You.....",
                        hintStyle: TextStyle(
                          color: ref.watch(themeProvider) == ThemeMode.light
                              ? Colors.grey // Light theme hint color
                              : Color(0xFF898b8e), // Dark theme hint color
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                      maxLines: null, // Allow the TextField to expand to multiple lines
                      minLines: 1, // Start with a single line
                    ),
                  )
                  ,
                  SizedBox(
                    width: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 18),
                    child: GestureDetector(
                        child: Icon(
                          Icons.send,
                          color: Colors.blue,
                        ),
                        onTap: () {

                          sendMessage(_controller.text);
                          _controller.clear();
                        },
                      ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
