import 'package:animate_do/animate_do.dart';
import 'package:chimini/ImageScreen.dart';
import 'package:chimini/feature_box.dart';
import 'package:chimini/openai_service.dart';
import 'package:chimini/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'Chat.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  final flutterTts = FlutterTts();
  bool isSpeaking = false;
  String lastWords = '';
  final OpenAIService openAIService = OpenAIService();
  final start = 200;
  final delay = 200;
  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }
  Future<void> initSpeechToText() async{
    speechToText.initialize();
    print("initSpeechToText() Listening");
    setState((){});
  }
  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);

    // Set the completion handler to update the state when TTS finishes speaking
    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false; // Set to false when speaking completes
      });
      print("TTS Finished Speaking");
    });

    setState(() {});
  }

  /// Each time to start a speech recognition session
  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    print("Start Listening");
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  Future<void> stopListening() async {
    await speechToText.stop();
    final speech = await openAIService.GeminiAPI(lastWords); // Call your Gemini API
    await systemSpeak(speech); // Speak out the response
    print("Final Processed Response: $speech");
    print("Stop Listening");
    setState(() {

    });
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
      print("Recognized Words: $lastWords");
      handleListeningState();
    });
  }

  Future<void> systemSpeak(String content) async {
    setState(() {
      isSpeaking = true; // Set isSpeaking to true when system starts speaking
    });

    await flutterTts.speak(content);
  }
  Future<void> stopSystemSpeak() async {
    await flutterTts.stop(); // Stop any ongoing speech
    isSpeaking = false;
    setState(() {
    });
    print("TTS Stopped");
  }
  void handleListeningState() {
    if (!speechToText.isListening) {
      stopListening();
      print("Listening has automatically stopped due to silence.");
      setState(() {});
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
    print("Stop Listening");
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[ Scaffold(
        appBar: AppBar(
          title: Text("Chimini"),
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                // Open the side navigation drawer using the correct context
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Profile Section
              UserAccountsDrawerHeader(
                accountName: Text("Sandeep Kushwaha"),
                accountEmail: Text("sandeepkush880@gmail.com"),
                  currentAccountPicture: ClipOval(
                    child: Image.asset(
                      'assets/images/profile_pic_final.png',
                      fit: BoxFit.cover, // This ensures the image is cropped and scaled properly
                      width: 100.0, // Set the size of the image
                      height: 100.0, // Set the size of the image
                    ),
                  ),

              ),
              // Contact Details Section


            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Virtual Assistant Picture
              ZoomIn(
                duration: Duration(milliseconds: 200),
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        height: 120,
                        width: 120,
                        margin: const EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                          color: Pallete.assistantCircleColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Container(
                      height: 125,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image:
                                  AssetImage('assets/images/virtualAssistant.png'))),
                    )
                  ],
                ),
              ),
              // Chatt Bubble
              FadeInRight(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin: EdgeInsets.symmetric(horizontal: 20).copyWith(top: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Pallete.borderColor, width: 2),
                      borderRadius:
                          BorderRadius.circular(25).copyWith(topLeft: Radius.zero)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      "Hi, I'm Chimini, your virtual assistant. How can I help you?",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Cera Pro',
                          color: Pallete.mainFontColor),
                    ),
                  ),
                ),
              ),
              // Feature Text
              SlideInRight(
                duration: Duration(milliseconds: 100),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 5,left: 22),
                  child: Text(
                    'Here are some Features 😉',
                    style: TextStyle(
                      fontFamily: 'Cera Pro',
                      color: Pallete.mainFontColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic
                    ),
                  ),
                ),
              ),
              // Features List
              Column(
                children: [
                  SlideInLeft(
                    delay: Duration(milliseconds: start),
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to the chat screen when tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => chat(),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          FeatureBox(
                            color: Pallete.firstSuggestionBoxColor,
                            headerText: 'Chimini Chat',
                            descriptionText: 'A smarter way to stay Organized and informed with Chimin', onPressed: () {
                              Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => chat(),
                            ),
                          );  },
                          ),
                          SizedBox(height: 8), // Space between FeatureBox and "Click Me"
                        ],
                      ),
                    ),
                  )
                  ,
                  SlideInLeft(
                    delay: Duration(milliseconds: start + delay),
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to the chat screen when tapped

                      },
                      child: Column(
                        children: [
                          FeatureBox(
                            color: Pallete.firstSuggestionBoxColor,
                            headerText: 'Image Generator',
                            descriptionText: 'Get Inspired and stay creative with your personal Assistant powered by Chimini Imagine', onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageScreen(),
                              ),
                            );
                          },
                          ),
                          SizedBox(height: 8), // Space between FeatureBox and "Click Me"

                        ],
                      ),
                    ),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start + 2* delay),
                    child: FeatureBox(color: Pallete.thirdSuggestionBoxColor,
                        headerText: 'Smart Voice Suggestion',
                        descriptionText: 'Get the best of both words with a voice assistant powered by ChatGPT and Dall-E', onPressed: () {

                      },),
                  ),
                ],
              )
      
            ],
      
           ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            print("Floating Action Button Clicked");

            if (isSpeaking) {
              await stopSystemSpeak(); // Stop speaking
              print("Stopped System Speaking");
              setState(() {
              });
              return; // Return early to avoid further actions
            }

            if (await speechToText.hasPermission && !speechToText.isListening) {
              // Start listening
              await startListening();
              print("Started Listening");
            } else if (speechToText.isListening) {
              // Stop listening
              await stopListening();
              print("Stopped Listening");
            } else {
              // Initialize if not set up
              await initSpeechToText();
              print("Initialized Speech");
            }
      
            setState(() {}); // Ensure the UI updates to reflect changes
          },
          backgroundColor: Pallete.firstSuggestionBoxColor,
          child: Icon(
            speechToText.isListening
                ? Icons.headset  // Listening state
                : isSpeaking
                ? Icons.stop_circle_sharp  // Speaking state
                : Icons.mic,  // Mic state (when not speaking or listening)
          )
          ,
        ),
      ),
    ],
    );
  }
}
