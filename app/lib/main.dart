import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fuzzy_search/fuzzy_search.dart';

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
  var filteredList = <String>[];

  @override
  void initState() {
    super.initState();
    _loadAssets();

    textController.addListener(() {
      _search(textController.value.text);
    });
  }

  void _search(String needle) {
    filteredList.clear();

    var watch = Stopwatch();
    watch.start();

    for (var hay in dataList) {
      var present = fuzzySearch(hay, needle);
      if (present != null) {
        filteredList.add(hay);
      }
    }

    print(
        'N(${dataList.length}) -> ${filteredList.length} = ${watch.elapsed.inMilliseconds} msecs');

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
        return buildTile(data[i]);
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

  Future<void> _loadAssets() async {
    var data = await DefaultAssetBundle.of(context).loadString(
      '../benchmark/linux.txt',
      cache: false,
    );
    var list = LineSplitter.split(data).toList();

    setState(() {
      dataList = list;
    });
  }
}

Widget buildTile(String t) {
  return ListTile(
    title: Text(t),
  );
}
