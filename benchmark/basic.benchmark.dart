import 'package:fuzzy_search/fuzzy_search.dart';
import 'package:path/path.dart' show dirname, join;

import 'dart:io';
import 'dart:convert';

var templateDataFile = 'linux.txt';

class TemplateBenchmark {
  var list = <String>[];

  // Runs a short version of the benchmark. By default invokes [run] once.
  void warmup() {
    run();
  }

  // Exercises the benchmark. By default invokes [run] 10 times.
  void exercise() {
    for (var i = 0; i < 10; i++) {
      run();
    }
  }

  void run() {
    for (var hay in list) {
      fuzzySearch(hay, 'string');
    }
  }

  Future<void> setup() async {
    var scriptDir = dirname(Platform.script.path);

    list = await File(join(scriptDir, templateDataFile))
        .openRead()
        .transform(utf8.decoder)
        .transform(LineSplitter())
        .toList();
  }

  // Not measures teardown code executed after the benchmark runs.
  void teardown() {}

  // Measures the score for this benchmark by executing it repeatedly until
  // time minimum has been reached.
  static double measureFor(Function f, int minimumMillis) {
    var iter = 0;
    var watch = Stopwatch();
    watch.start();
    var elapsed = 0;
    while (elapsed < minimumMillis) {
      f();
      elapsed = watch.elapsedMilliseconds;
      iter++;
    }
    return elapsed / iter;
  }

  // Measures the score for the benchmark and returns it.
  double measure() {
    // Warmup for at least 100ms. Discard result.
    measureFor(warmup, 100);
    // Run the benchmark for at least 2000ms.
    var result = measureFor(exercise, 2000);
    teardown();
    return result;
  }
}

void main() async {
  var t = TemplateBenchmark();
  await t.setup();

  var result = t.measure();
  print('(RunTime): $result msecs.');
}
