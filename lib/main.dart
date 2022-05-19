import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:regex_query/main_drawer.dart';
import 'package:regex_query/main_body.dart';

void main() {
  runApp(MaterialApp(
    title: "Regex Query Tool",
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Colors.black87,
      backgroundColor: const Color(0xFFEFFFFD),
      drawerTheme: const DrawerThemeData(
        backgroundColor: Color(0xFF85F4FF),
        elevation: 20,
      ),
    ),
    darkTheme: ThemeData(),
    initialRoute: '/',
    routes: {
      '/': (context) => const RegexQuery(),
    },
  ));
}

class RegexQuery extends StatefulWidget {
  const RegexQuery({Key? key}) : super(key: key);

  @override
  State<RegexQuery> createState() => _RegexQueryState();
}

class _RegexQueryState extends State<RegexQuery> {
  final Color _backgroundColor = const Color(0xFFEFFFFD);

  String textToAdd = '';

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    final _screenWidth = _screenSize.width;

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Column(
        children: [
          SizedBox(
            child: AppBar(
              backgroundColor: const Color(0xFFC8FFDE),
              centerTitle: true,
              title: Text(
                'Regex Query Tool',
                style: GoogleFonts.stalinistOne(
                    textStyle:
                        const TextStyle(color: Colors.black87, fontSize: 30)),
              ),
              leading: Text(
                '.*',
                style: GoogleFonts.xanhMono(
                    textStyle:
                        const TextStyle(color: Colors.black87, fontSize: 45)),
              ),
              actions: [
                Text(
                  '*. ',
                  style: GoogleFonts.xanhMono(
                      textStyle:
                          const TextStyle(color: Colors.black87, fontSize: 45)),
                ),
              ],
              toolbarHeight: 1000,
            ),
            width: _screenWidth,
            height: 50,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            DrawerControllerMain(
              textToAdd: (stuff) {
                setState(() {
                  textToAdd = stuff;
                });
              },
            ),
            QueryBody(
              textToAdd: textToAdd,
            ),
          ]),
        ],
      ),
    );
  }
}
