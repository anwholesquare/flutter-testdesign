import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main () {
  runApp (MyApp());
}


class MyApp extends StatefulWidget {

  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;

  void setDarkMode(bool isDark) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("isDark", isDark);
  getDarkMode();
  }

  Future<bool> getDarkMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool("isDark") ?? false;
    setState(() {});
    return isDark;
  }

  @override
  void initState() {
    super.initState();
    getDarkMode();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        darkTheme: ThemeData(
          fontFamily: GoogleFonts.poppins().fontFamily,
          brightness: Brightness.dark,
        ),
        themeMode: isDark? ThemeMode.dark : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        routes: {
          "/":(context) => HomePage(setDarkMode: setDarkMode, isDark: isDark),
        }
    );
  }
}

class HomePage extends StatefulWidget {
  Function setDarkMode;
  bool isDark = false;
  HomePage({super.key, required this.setDarkMode, required this.isDark});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String urlStr = "https://www.google.com";
  Function? setDarkMode;
  bool isDark = false;

  @override
  void initState() {
    super.initState();
    setDarkMode = widget.setDarkMode;
    isDark = widget.isDark;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child : SafeArea(
        child: Stack(
          children: [
            Positioned(
                top: 24, right: 24,
                child: IconButton(
                onPressed: () {
                  isDark = !isDark;
                  widget.setDarkMode(isDark);
                  setState(() {
                    
                  });
                  
                },
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
              )),
            Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                    children: [
                      const Text("Webview Flutter", style: TextStyle(fontSize: 30)),
                      const SizedBox(height: 20),
                      TextFormField(
                        onChanged: (value) {
                          urlStr = value;
                        },
                        decoration: const InputDecoration(
                          labelText: "Enter URL",
                          hintText: "Enter URL",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => WebPage(url: urlStr)));
                        },
                        child: const Text("Browse"),
                      ),
                    ],
                  ),
              ),
            ),
      ),
          ],
        ))
    );
  }
}

class WebPage extends StatelessWidget {
  String url = "https://www.google.com";
  WebPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: const Text('WebView Example'),
    ),
    body: WebView(
      initialUrl: url,
      javascriptMode: JavascriptMode.unrestricted,
    ),
  );
  }
}