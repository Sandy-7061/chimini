# Chimini AI Chat Application

Welcome to the **Chimini AI Chat Application**! This project is a Flutter-based AI chat application utilizing the Gemini AI API to generate and display responses in a chat-like interface. It mimics the functionality of popular AI chat systems like ChatGPT.

## 📋 Features

- **AI-Powered Chat**: Engage in conversations with an AI-powered by Gemini AI.
- **Text-to-Image Generation**: Generate images based on text prompts using AI.
- **Dark Mode Support**: Toggle between light and dark themes.
- **Speech-to-Text**: Convert spoken words into text to send messages.
- **Text-to-Speech**: Convert AI responses into spoken words.

## 🚀 Setup Instructions

### Prerequisites

- Flutter installed on your system.
- Access to the Gemini AI API.

### Installation Steps

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-repository-url.git
   cd chimini-ai-chat
   ```

2. **Install Dependencies**:
   Navigate to the project directory and run the following command to install dependencies:
   ```bash
   flutter pub get
   ```

3. **Configure Environment Variables**:
   - Create a `.env` file in the root directory.
   - Add your Gemini AI API key:
     ```bash
     OPENAI_API_KEY=your_api_key_here
     ```

4. **Run the Application**:
   Use the following command to start the application:
   ```bash
   flutter run
   ```

### 🛠️ Dependencies

Add the following dependencies to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  speech_to_text: ^7.0.0
  http: ^1.2.2
  flutter_dotenv: ^5.2.1
  flutter_tts: ^4.2.1
  animate_do: ^3.3.4
  flutter_riverpod: ^2.6.1
  google_generative_ai: ^0.4.6
```

### 📑 Usage

1. **Set Up API Key**:
   Replace placeholders with your API key in the following files:

   - In `spenai_service.dart`:
     ```dart
     final model = GenerativeModel(
       model: "gemini-1.5-flash",
       apiKey: "your_api_key_here" // Your Gemini API KEY
     );
     final prompt = controller.text.trim();
     final content = [Content.text(prompt)];
     ```

   - In `Chat.dart`:
     ```dart
     https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$OpenApiKey
     ```

2. **Chat with AI**: Type your message in the text field and hit send to receive AI-generated responses.

3. **Switch Themes**: Use the theme toggle button in the app bar to switch between light and dark modes.

### 📸 Screenshots

Include a section with screenshots of the application demonstrating its features:
1. **Light Mode Chat Screen**
2. **Dark Mode Chat Screen**
3. **Image Generation Result**

### 📞 Contact

For any queries or support, feel free to reach out:

- 📧 Email: [sandeepkush880@gmail.com](mailto:sandeepkush880@gmail.com)
- 📱 Mobile: [+91 7024520740](tel:+917024520740)

### 📝 License

This project is licensed under the MIT License. See the LICENSE file for more details.

---

Feel free to contribute and improve this project! 😊

---

**Happy Coding!** 🧑‍💻✨