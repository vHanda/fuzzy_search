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

  @override
  void initState() {
    super.initState();

    dataList = small_data_set.data;

    textController.addListener(() {
      _search(textController.value.text);
    });
  }

  void _search(String needle) {
    print('###############################');
    print('###############################');
    print('###############################');
    print('###############################');
    print('###############################');
    var watch = Stopwatch();
    watch.start();

    filteredList.clear();
    var fs = FuzzySearch(dataList, mappingFn: (String e) => e);
    filteredList = fs.match(needle);

    // print(
    // 'N(${dataList.length}) -> ${filteredList.length} = ${watch.elapsed.inMilliseconds} msecs');

    setState(() {});
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
          return buildTile(0, data[i] as String);
        }
        var result = data[i] as FuzzySearchResult<String>;
        return buildTile(result.score, result.obj);
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

Widget buildTile(int score, String t) {
  return ListTile(
    leading: Text(score.toString()),
    title: Text(t),
  );
}
