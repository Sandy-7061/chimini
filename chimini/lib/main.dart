import 'package:chimini/Theme/ThemeNotifier.dart';
import 'package:chimini/Theme/themes.dart';
import 'package:chimini/home_page.dart';
import 'package:chimini/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(child: MyApp())
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context,WidgetRef ref) {

    final thememode = ref.watch(themeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chimini',
      theme: lightmode,
      darkTheme: darkmode,
      themeMode: thememode,
      home: const HomePage(),
    );
  }
}

