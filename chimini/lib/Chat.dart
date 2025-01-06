import 'package:chimini/Theme/ThemeNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'Message.dart';

class chat extends ConsumerStatefulWidget {
  const chat({super.key});

  @override
  ConsumerState<chat> createState() => chatState();
}


class chatState extends ConsumerState<chat> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final List<Message> message = [
    Message(text: "😊 What can i do for you 😍", isuser: false)
  ];
  bool isloading = false;
  callgeminiModel() async {
    try {
      if (controller.text.isNotEmpty) {
        // Start loading and add the user message
        setState(() {
          isloading = true; // Set loading to true as soon as the button is clicked
          message.add(Message(text: controller.text, isuser: true));
        });

        final model = GenerativeModel(
            model: "gemini-1.5-flash",
            apiKey: ""); // Your Gemmini API KEY from  "https://aistudio.google.com/apikey" ; 
        final prompt = controller.text.trim();
        final content = [Content.text(prompt)];

        // Fetch the response from the model
        final response = await model.generateContent(content);
        print(response);
        setState(() {
          // Clean up the response text by removing unwanted characters
          String cleanedResponse = response.text!
              .replaceAll("**", '\n')
              .replaceAll("*", '')
          ;
          // Replace *** with a line break
             // For italics

          // Add the cleaned-up response to the message list
          message.add(Message(text: cleanedResponse, isuser: false));
          scrollToBottom(); // Scroll to the bottom
          isloading = false; // Set loading to false once the message is added
        });


        controller.clear(); // Clear the text input field after sending the message
      }
    } catch (e) {
      print("Gemini Error: $e");
      setState(() {
        isloading = false; // Stop loading if there's an error
      });
    }
  }
  void scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        // Get the screen height and keyboard height
        double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

        // Scroll only if the keyboard is open or list is near bottom
        if (keyboardHeight > 0 || scrollController.position.pixels == scrollController.position.maxScrollExtent) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 400),
            curve: Curves.easeOut,
          );
        }
      }
    });
  }

  ThemeMode currenttheme = ThemeMode.light;

  @override
  void initState() {
    getcurrentTheme();
    super.initState();
  }
  getcurrentTheme(){
    currenttheme = ref.read(themeProvider);
    print("Current Theme is  : $currenttheme");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chimini"),
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
      )
      ,
      body:
      Column(
        children: [
          Expanded(
            child: ListView.builder(
                controller: scrollController,
                itemCount: message.length,
                itemBuilder:(context,index){
                  final messagee = message[index];
                  return ListTile(
                    title: Align(
                      alignment: messagee.isuser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: messagee.isuser ? Colors.blue : Colors.grey[200],
                            borderRadius: messagee.isuser ? BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                              bottomLeft: Radius.circular(16)
                            ) :
                            BorderRadius.only(
                                topRight: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                                bottomLeft: Radius.circular(16)
                          )

                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8,right: 8),
                            child: Text(messagee.text,
                            style: TextStyle(
                                color: messagee.isuser ? Colors.white : Colors.black,
                              fontSize: 14
                            ),),
                          )),
                    ),
                  );
                }
            ),
          ),

          // User Input


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
                          controller: controller,
                          style: TextStyle(
                            color: ref.watch(themeProvider) == ThemeMode.light
                                ? Colors.black // Light theme hint color
                                : Colors.black, // Dark theme hint color
                          ),
                          decoration: InputDecoration(
                            hintText: "Chimini Here.....",
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

                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      isloading
                          ? Padding(
                        padding: EdgeInsets.all(8),
                        child: CircularProgressIndicator(),
                      )
                          : Padding(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          child: Icon(
                            Icons.send,
                            color: Colors.blue,
                          ),
                          onTap: () {

                            callgeminiModel();// Call the function when the button is clicked
                            controller.clear();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              )
        ],
      ),
    );
  }
}
