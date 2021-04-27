import 'package:benchmark/benchmark.dart';
import 'package:fuzzy_search/fuzzy_search.dart';

import 'dart:io';
import 'dart:convert';

var path = './data.txt';

void main() {
  var list = <String>[];

  setUp(() async {
    list = await File(path)
        .openRead()
        .transform(utf8.decoder)
        .transform(LineSplitter())
        .toList();
  });

  benchmark('Simple Search', () {
    for (var hay in list) {
      fuzzySearch(hay, 'string');
    }
  });
}
