import 'package:fuzzy_search/fuzzy_search.dart';
import 'package:test/test.dart';

void main() {
  test('Add task', () {
    var input = [
      'Add task after',
      'Add task before',
      'Add task',
      // 'Add subtask to end',
      // 'Add subtask to start',
    ];

    var fs = FuzzySearch(input, mappingFn: (String a) => a);
    var results = fs.match('Add task');
    expect(results.length, input.length);

    expect(results[0].obj, 'Add task');
    expect(results[0].score, greaterThan(results[1].score));
  });
}
