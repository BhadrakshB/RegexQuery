import 'package:flutter/material.dart';

dynamic strip(String string) {
  RegExp stripOffSpaces = RegExp(r'\S.+\S');
  return stripOffSpaces.firstMatch(string)?.group(0);
}

class Pair {
  dynamic a;
  dynamic b;

  Pair(this.a, this.b);
}

class QueryBody extends StatefulWidget {
  String textToAdd;
  QueryBody({Key? key, required this.textToAdd}) : super(key: key);

  @override
  State<QueryBody> createState() => _QueryBodyState();
}

class _QueryBodyState extends State<QueryBody> {
  late TextEditingController regexController = TextEditingController();
  late TextEditingController textController = TextEditingController();

  late RegExp regex = RegExp(regexController.value.text);
  late String text = textController.value.text;
  List matches = [];

  void checkRegex(regularexp, text) {
    matches.clear();

    try {
      regex = RegExp(regularexp);
      if (regularexp != '') {
        regex.allMatches(text).forEach((element) {
          if (element.groups([0]).elementAt(0)!.isNotEmpty) {
            matches.add(element.groups([0]).elementAt(0));
          }
        });
      }
    } on FormatException catch (e) {
      matches.clear();
      String message = e.message.split(':').first.trim() +
          ": " +
          e.message.split(":").last.trim();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      final snackBar = SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on RangeError {
      null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.textToAdd != '') {
      regexController
        ..value
        ..text = regexController.value.text + widget.textToAdd;
      widget.textToAdd = '';
      checkRegex(regexController.value.text, text);
    }

    return Expanded(
      child: Container(
          color: Colors.transparent,
          height: MediaQuery.of(context).size.height - 50,
          child: Column(
            children: [
              Container(
                height: 60,
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                  color: Color(0xFFA5F2C6),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Regular Expression',
                  ),
                ),
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    checkRegex(value, text);
                    widget.textToAdd = '';
                  });
                },
                controller: regexController,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
              ),
              Container(
                height: 50,
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                  color: Color(0xFFA5F2C6),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Text',
                  ),
                ),
              ),
              Expanded(
                  child: TextField(
                onChanged: (query) {
                  setState(() {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    text = query;
                    checkRegex(regexController.value.text, text);
                  });
                },
                controller: textController,
                style: const TextStyle(fontSize: 20, letterSpacing: 2),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                  border: InputBorder.none,
                ),
              )),
              Container(
                height: 50,
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                  color: Color(0xFFA5F2C6),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Matches',
                        ),
                        Row(
                          children: [
                            Card(
                              color: const Color(0xFFA5F2C6).withAlpha(120),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Count: ${matches.length}',
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            )
                          ],
                        ),
                      ]),
                ),
              ),
              Container(
                height: matches.isEmpty ? 50 : 300,
                padding: const EdgeInsets.all(15),
                child: matches.isNotEmpty
                    ? SingleChildScrollView(
                        child: Wrap(
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            spacing: 15,
                            direction: Axis.horizontal,
                            runSpacing: 15,
                            children: matches
                                .map((e) => Container(
                                      alignment: Alignment.centerLeft,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade400,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                          shape: BoxShape.rectangle),
                                      width: e.toString().length * 10 + 20,
                                      padding: const EdgeInsets.all(7),
                                      child: Center(
                                        child: Text(
                                          e.toString(),
                                          softWrap: false,
                                          maxLines: 1,
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),
                                    ))
                                .toList()),
                      )
                    : Container(),
              )
            ],
          )),
    );
  }
}
