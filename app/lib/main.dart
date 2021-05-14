import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fuzzy_search/fuzzy_search.dart';

// import 'data/linux_repo_paths.dart' as linux_repo_paths;
import 'data/small_data_set.dart' as small_data_set;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: FuzzySearchApp()),
    );
  }
}

class FuzzySearchApp extends StatefulWidget {
  @override
  _FuzzySearchAppState createState() => _FuzzySearchAppState();
}

class _FuzzySearchAppState extends State<FuzzySearchApp> {
  var textController = TextEditingController();
  var dataList = <String>[];
  var filteredList = <FuzzySearchResult>[];
  var prevNeedle = "";

  @override
  void initState() {
    super.initState();

    dataList = small_data_set.data;

    textController.addListener(() {
      _search(textController.value.text);
    });
  }

  void _search(String needle) {
    if (prevNeedle == needle) {
      return;
    }
    var watch = Stopwatch();
    watch.start();

    var fs = FuzzySearch(dataList, mappingFn: (String e) => e);
    var matches = fs.match(needle);

    print(
        'N($needle) -> ${filteredList.length} = ${watch.elapsed.inMilliseconds} msecs');

    setState(() {
      filteredList = matches;
      prevNeedle = needle;
    });
  }

  @override
  Widget build(BuildContext context) {
    var data = textController.text.isEmpty ? dataList : filteredList;
    var list = ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, i) {
        if (i >= data.length) {
          return Container();
        }
        if (data[i] is String) {
          return buildTile(0, data[i] as String, []);
        }
        var result = data[i] as FuzzySearchResult<String>;
        return buildTile(result.score, result.obj, result.indexes);
      },
    );

    return Column(
      children: [
        TextField(
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            hintText: 'Enter Something',
            contentPadding: EdgeInsets.all(20.0),
          ),
          controller: textController,
          autofocus: true,
        ),
        Expanded(
          child: Scrollbar(
            child: list,
            isAlwaysShown: true,
          ),
        ),
      ],
    );
  }
}

Widget buildTile(int score, String t, List<int> indexes) {
  var spans = <TextSpan>[];
  for (var i = 0; i < t.length; i++) {
    var char = String.fromCharCode(t.codeUnitAt(i));
    var span = TextSpan(
      text: char,
      style: indexes.contains(i)
          ? TextStyle(fontWeight: FontWeight.bold)
          : TextStyle(),
    );
    spans.add(span);
  }

  return ListTile(
    leading: Text(score.toString()),
    title: RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.black),
        children: spans,
      ),
    ),
  );
}
