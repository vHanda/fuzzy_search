import 'package:fuzzy_search/fuzzy_search.dart';
import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:path/path.dart' show dirname, join;

import 'dart:io';
import 'dart:convert';

var templateDataFile = 'data.txt';

class TemplateBenchmark extends BenchmarkBase {
  TemplateBenchmark() : super('Template');
  var list = <String>[];

  static void main() {
    TemplateBenchmark().report();
  }

  @override
  void run() {
    for (var hay in list) {
      fuzzySearch(hay, 'string');
    }
  }

  @override
  void setup() async {
    var scriptDir = dirname(Platform.script.path);

    list = await File(join(scriptDir, templateDataFile))
        .openRead()
        .transform(utf8.decoder)
        .transform(LineSplitter())
        .toList();
  }
}

void main() {
  // Run TemplateBenchmark
  TemplateBenchmark.main();
}
