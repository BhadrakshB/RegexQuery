import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Pair {
  final String type;
  final String example;

  Pair(this.type, this.example);
}

class DrawerControllerMain extends StatefulWidget {
  final Function(String) textToAdd;

  const DrawerControllerMain({Key? key, required this.textToAdd})
      : super(key: key);

  @override
  State<DrawerControllerMain> createState() => _DrawerControllerMainState();
}

class _DrawerControllerMainState extends State<DrawerControllerMain> {
  Map<String, bool> drawerControllerMapping = {
    "Menu": true,
    "Cheatsheet": false,
    "References": false,
  };

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: drawerControllerMapping['Cheatsheet'] == true
            ? CheatsheetDrawer(
                drawerControllerMapping: drawerControllerMapping,
                function: (boolean) {
                  setState(() {
                    drawerControllerMapping['Cheatsheet'] = boolean;
                  });
                },
              )
            :
            // References Drawer...
            drawerControllerMapping['References'] == true
                ? ReferenceDrawer(
                    drawerControllerMapping: drawerControllerMapping,
                    function: (boolean) {
                      setState(() {
                        drawerControllerMapping['References'] = boolean;
                      });
                    },
                    textToAdd: (stuff) {
                      setState(() {
                        widget.textToAdd(stuff);
                      });
                    },
                  )
                : MenuDrawer(
                    drawerControllerMapping: drawerControllerMapping,
                    function: (drawer) {
                      setState(() {
                        drawerControllerMapping[drawer] = true;
                      });
                    },
                  ));
  }
}

class MenuDrawer extends StatefulWidget {
  final Map drawerControllerMapping;
  final Function(String drawerName) function;

  const MenuDrawer(
      {Key? key, required this.drawerControllerMapping, required this.function})
      : super(key: key);

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  bool expanded = true;

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    // final _screenWidth = _screenSize.width;
    final _screenHeight = _screenSize.height;
    const _drawerColor = Color(0xFFD6FFF4);

    void drawerScale() {
      setState(() {
        expanded = !expanded;
      });
    }

    String linkedinURL =
        'https://www.linkedin.com/in/bhadraksh-bhargava-42aaba135/';
    String githubURL = 'https://github.com/FlashbadBB/';
    String mailURL = 'mailto:flashbadwork@gmail.com';

    return AnimatedContainer(
      key: const Key('1'),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutExpo,
      height: _screenHeight - 50,
      width: expanded ? 450 : 65,
      decoration: const BoxDecoration(color: _drawerColor),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          children: [
            ListTile(
              leading: const Icon(
                Icons.menu,
                size: 30,
              ),
              title: expanded
                  ? const Text(
                      'Menu',
                    )
                  : null,
              onTap: () {
                drawerScale();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.view_column_outlined,
                size: 30,
              ),
              title: expanded
                  ? const Text(
                      'Cheatsheet',
                    )
                  : null,
              onTap: () {
                setState(() {
                  widget.function('Cheatsheet');
                });
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.auto_stories_sharp,
                size: 30,
              ),
              title: expanded
                  ? const Text(
                      'References',
                    )
                  : null,
              onTap: () {
                setState(() {
                  widget.function('References');
                });
              },
            ),
          ],
        ),
        expanded
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'assets/mail.svg',
                        height: 25,
                        width: 25,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        if (await canLaunchUrlString(mailURL)) {
                          await launchUrlString(mailURL);
                        } else {
                          const SnackBar(
                              content: Text(
                                  "Unable to direct you to mail services"));
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'assets/linkedin.svg',
                        height: 25,
                        width: 25,
                        color: const Color(0xFF0A66C2),
                      ),
                      onPressed: () async {
                        if (await canLaunchUrlString(linkedinURL)) {
                          await launchUrlString(
                            linkedinURL,
                          );
                        } else {
                          SnackBar(
                              content: Text('Could not launch $linkedinURL'));
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'assets/github.svg',
                        height: 25,
                        width: 25,
                      ),
                      onPressed: () async {
                        if (await canLaunchUrlString(githubURL)) {
                          await launchUrlString(
                            githubURL,
                          );
                        } else {
                          SnackBar(
                              content: Text('Could not launch $githubURL'));
                        }
                      },
                    ),
                  ),
                ],
              )
            : Row()
      ]),
    );
  }
}

class ReferenceDrawer extends StatefulWidget {
  final Map drawerControllerMapping;
  final Function(bool) function;
  final Function(String) textToAdd;

  const ReferenceDrawer({
    Key? key,
    required this.drawerControllerMapping,
    required this.function,
    required this.textToAdd,
  }) : super(key: key);

  @override
  State<ReferenceDrawer> createState() => _ReferenceDrawerState();
}

class _ReferenceDrawerState extends State<ReferenceDrawer> {
  late FocusNode _searchBarFocusNode;
  late TextEditingController _searchBarController;

  late ScrollController _scrollController;

  @override
  void initState() {
    _searchBarController = TextEditingController();
    _searchBarFocusNode = FocusNode();
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _searchBarController.dispose();
    _searchBarFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool expanded = true;
  bool show = true;

  final Map data = {
    'Character Classes': [
      Pair('character set', '[ABC]'),
      Pair('negated set', '[^ABC]'),
      Pair('range', '[A-Z]'),
      Pair('dot', '.'),
      Pair('match any', r'[\s\S]'),
      Pair('word', r'\w'),
      Pair('not word', r'\W'),
      Pair('digit', r'\d'),
      Pair('not digit', r'\D'),
      Pair('whitespace', r'\s'),
      Pair('not whitespace', r'\S'),
      Pair('unicode category', r'\p{L}'),
      Pair('not unicode category', r'\P{L}'),
      Pair('unicode script', r'\p{Han}'),
      Pair('not unicode script', r'\P{Han}'),
    ],
    'Anchors': [
      Pair('beginning', r'^'),
      Pair('end', r'$'),
      Pair('word boundary', r'\b'),
      Pair('not word boundary', r'\B'),
    ],
    'Escaped characters': [
      Pair('reserved characters', r'\+'),
      Pair('octal escape', r'\000'),
      Pair('hexadecimal escape', r'\xFF'),
      Pair('unicode escape', r'\uFFFF'),
      Pair('extended unicode escape', r'\u{FFFF}'),
      Pair('control character escape', r'\cT'),
      Pair('tab', r'\t'),
      Pair('line feed', r'\n'),
      Pair('vertical tab', r'\v'),
      Pair('form feed', r'\f'),
      Pair('carriage return', r'\r'),
      Pair('null', r'\0'),
    ],
    'Groups and References': [
      Pair('capturing group', r'(ABC)'),
      Pair('named capturing group', r'(?<name>ABC)'),
      Pair('numeric reference', r'\1'),
      Pair('non-capturing group', r'(?:ABC)'),
    ],
    'Lookaround': [
      Pair('positive lookahead', r'(?=ABC)'),
      Pair('negative lookahead', r'(?!ABC)'),
      Pair('positive lookbehind', r'(?<=ABC)'),
      Pair('negative lookbehind', r'(?<!ABC)'),
    ],
    'Quantifiers and Alterations': [
      Pair('plus', '+'),
      Pair('star', '*'),
      Pair('quantifier', '{1,3}'),
      Pair('optional', '?'),
      Pair('lazy', '?'),
      Pair('alternation', '|'),
    ],
    'Substitution': [
      Pair('match', r'$&'),
      Pair('capture group', r'$1'),
      Pair('before match', r'$`'),
      Pair('after match', '\$\''),
      Pair(r'escaped $', r'$$'),
      Pair('escaped characters', r'\n'),
    ],
    'Flags': [
      Pair('ignore case', r'i'),
      Pair('global search', r'g'),
      Pair('multiline', r'm'),
      Pair('unicode', 'u'),
      Pair(r'sticky', r'y'),
      Pair('dotall', 's'),
    ],
  };

  String whichReference = 'Menu';

  List resultsStack = [];

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    // final _screenWidth = _screenSize.width;
    final _screenHeight = _screenSize.height;
    const _drawerColor = Color(0xFFD6FFF4);

    void drawerScale() {
      setState(() {
        show = !show;
        expanded = !expanded;
      });
    }

    return AnimatedContainer(
      key: const Key('3'),
      duration: const Duration(milliseconds: 250),
      curve: expanded ? Curves.easeIn : Curves.easeOut,
      height: _screenHeight - 50,
      width: expanded ? 450 : 60,
      decoration: const BoxDecoration(color: _drawerColor),
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              expanded
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                setState(() {
                                  if (whichReference == 'Menu') {
                                    widget.function(false);
                                  } else {
                                    whichReference = 'Menu';
                                  }
                                });
                              });
                            },
                            icon: const Icon(Icons.arrow_back_ios_new),
                          ),
                          const SizedBox(
                            width: 275,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                drawerScale();
                              });
                            },
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.auto_stories_outlined,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('References'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              widget.function(false);
                            });
                          },
                          icon: const Icon(Icons.arrow_back_ios_new),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.auto_stories_outlined,
                            size: 30,
                          ),
                          onPressed: () {
                            setState(() {
                              drawerScale();
                            });
                          },
                        ),
                      ],
                    ),
              const SizedBox(
                height: 10,
              ),
              show
                  ? Container(
                      height: 70,
                      padding: const EdgeInsets.only(bottom: 15),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 214, 255, 241),
                      ),
                      child: SizedBox(
                        child: ListTile(
                          trailing: SizedBox(
                            height: 15,
                            width: 20,
                            child: IconButton(
                              padding: const EdgeInsets.only(top: 15),
                              icon: const Icon(Icons.search_rounded),
                              onPressed: () {
                                _searchBarFocusNode.requestFocus();
                              },
                            ),
                          ),
                          title: TextField(
                            controller: _searchBarController,
                            focusNode: _searchBarFocusNode,
                            onChanged: (query) {
                              if (query != '') {
                                resultsStack.clear();
                                for (int i = 0; i < data.values.length; i++) {
                                  var listOfData = data.values.elementAt(i);
                                  for (int j = 0; j < listOfData.length; j++) {
                                    if (listOfData
                                            .elementAt(j)
                                            .example
                                            .contains(query) |
                                        listOfData
                                            .elementAt(j)
                                            .type
                                            .contains(query)) {
                                      resultsStack.add(listOfData.elementAt(j));
                                    }
                                  }
                                }
                              } else {
                                resultsStack.clear();
                                _searchBarController.clear();
                              }
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              prefixIconConstraints: const BoxConstraints(
                                  maxHeight: 30, maxWidth: 40),
                              prefixIcon: _searchBarController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear_sharp),
                                      onPressed: () {
                                        setState(() {
                                          resultsStack.clear();
                                          _searchBarController.clear();
                                        });
                                      },
                                    )
                                  : null,
                              contentPadding:
                                  const EdgeInsets.only(left: 15, top: 15),
                              hintText: 'Search',
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              show
                  ? Container(
                      width: 450,
                      height: 300,
                      decoration: const BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          spreadRadius: -12.0,
                          blurRadius: 1.0,
                        ),
                      ], color: Color.fromARGB(255, 148, 215, 193)),
                      child: Scrollbar(
                        thumbVisibility: true,
                        interactive: true,
                        controller: _scrollController,
                        child: resultsStack.isEmpty &
                                _searchBarController.text.isEmpty
                            ? ListView.builder(
                                controller: _scrollController,
                                shrinkWrap: true,
                                itemCount: whichReference == 'Menu'
                                    ? data.keys.length
                                    : data[whichReference].length,
                                itemBuilder: (context, index) {
                                  return whichReference == 'Menu'
                                      ? ListTile(
                                          onTap: () {
                                            setState(() {
                                              whichReference =
                                                  data.keys.elementAt(index);
                                            });
                                          },
                                          title: Text(
                                              '${data.keys.elementAt(index)}'),
                                          trailing: const SizedBox(
                                            height: 15,
                                            width: 20,
                                            child: Icon(Icons
                                                .keyboard_arrow_right_rounded),
                                          ),
                                        )
                                      : ListTile(
                                          onTap: () {
                                            widget.textToAdd(
                                                data[whichReference]
                                                    .elementAt(index)
                                                    .example);
                                          },
                                          title: Text(
                                              '${data[whichReference].elementAt(index).type}'),
                                          trailing: SizedBox(
                                            height: 15,
                                            width: 45,
                                            child: Text(
                                                '${data[whichReference].elementAt(index).example}'),
                                          ),
                                        );
                                },
                              )
                            : ListView.builder(
                                controller: _scrollController,
                                shrinkWrap: true,
                                itemCount: resultsStack.length,
                                itemBuilder: (BuildContext context, index) {
                                  return ListTile(
                                    onTap: () {
                                      setState(() {});
                                    },
                                    title: Text(
                                        '${resultsStack.elementAt(index).type}'),
                                    trailing: SizedBox(
                                      height: 15,
                                      width: 44,
                                      child: Text(
                                          '${resultsStack.elementAt(index).example}'),
                                    ),
                                  );
                                }),
                      ))
                  : const SizedBox.shrink(),
              show
                  ? const SizedBox(
                      height: 300,
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: SelectableText(
                          '''Information on all of the tokens available to create regular expressions.

Click the tile to load it.''',
                          style: TextStyle(fontSize: 20, color: Colors.black87),
                        ),
                      ),
                    )
                  : const SizedBox.shrink()
            ]),
      ),
    );
  }
}

class CheatsheetDrawer extends StatefulWidget {
  final Map drawerControllerMapping;
  final Function(bool) function;

  const CheatsheetDrawer(
      {Key? key, required this.drawerControllerMapping, required this.function})
      : super(key: key);

  @override
  State<CheatsheetDrawer> createState() => _CheatsheetDrawerState();
}

class _CheatsheetDrawerState extends State<CheatsheetDrawer> {
  bool expanded = true;
  bool show = true;

  final Map data = {
    'Character Classes': [
      Pair('Any character except newline', r'.'),
      Pair('word, digit, whitespace', r'\w \d \s'),
      Pair('NOT word, digit, whitespace', r'\W \D \S'),
      Pair('any of a, b or c', '[abc]'),
      Pair('NOT a, b or c', r'[^abc]'),
      Pair('Character between a & g', r'[a-g]'),
    ],
    'Anchors': [
      Pair('Start / End of the string', r'^ , &'),
      Pair('word, not-word boundary', r'\b \B'),
    ],
    'Escaped characters': [
      Pair('escaped special characters', r'\. \* \\'),
      Pair('tab, linefeed, carriage return', r'\t \n \r'),
    ],
    'Groups and References': [
      Pair('capturing group', r'(abc)'),
      Pair('back-reference to group #1', r'\1'),
      Pair('non-capturing group', r'(?:ABC)'),
      Pair('positive lookahead', r'(?=ABC)'),
      Pair('negative lookahead', r'(?!ABC)'),
    ],
    'Quantifiers and Alterations': [
      Pair('0 or more, 1 or more, 0 or 1', 'a*, a+, a?'),
      Pair('exactly five, two or more', 'a{5}, a{2,}'),
      Pair('between one & three', 'a{1,3}'),
      Pair('match as few as possible', 'a+?, a{2,}?'),
      Pair('match ab or cd', 'ab|cd'),
    ]
  };

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    final _screenHeight = _screenSize.height;
    const _drawerColor = Color(0xFFD6FFF4);

    void drawerScale() {
      setState(() {
        show = !show;
        expanded = !expanded;
      });
    }

    return AnimatedContainer(
      onEnd: () {
        if (expanded == true) {}
      },
      key: const Key('2'),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      height: _screenHeight - 50,
      width: expanded ? 450 : 60,
      decoration: const BoxDecoration(color: _drawerColor),
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              expanded
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                setState(() {
                                  widget.function(false);
                                });
                              });
                            },
                            icon: const Icon(Icons.arrow_back_ios_new),
                          ),
                          const SizedBox(
                            width: 275,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                drawerScale();
                              });
                            },
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.auto_stories_outlined,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Cheatsheet'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              widget.function(false);
                            });
                          },
                          icon: const Icon(Icons.arrow_back_ios_new),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.auto_stories_outlined,
                            size: 30,
                          ),
                          onPressed: () {
                            setState(() {
                              drawerScale();
                            });
                          },
                        ),
                      ],
                    ),
              const SizedBox(
                height: 10,
              ),
              show
                  ? Container(
                      width: 450,
                      height: 1000,
                      decoration: const BoxDecoration(),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.keys.length,
                          itemBuilder: (context, index) {
                            return Column(children: [
                              const Divider(color: Colors.black87),
                              ListTile(
                                title: Text('${data.keys.elementAt(index)}'),
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      data[data.keys.elementAt(index)].length,
                                  itemBuilder: ((context, index1) {
                                    return Card(
                                      elevation: 0,
                                      color: Colors.transparent,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10.0,
                                          right: 10.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                '${data[data.keys.elementAt(index)].elementAt(index1).example}',
                                              ),
                                              flex: 1,
                                            ),
                                            Flexible(
                                              child: Text(
                                                  '${data[data.keys.elementAt(index)].elementAt(index1).type}'),
                                              flex: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }))
                            ]);
                          }),
                    )
                  : const SizedBox()
            ]),
      ),
    );
  }
}
