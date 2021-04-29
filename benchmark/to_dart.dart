import 'package:path/path.dart' show dirname, join;

import 'dart:io';
import 'dart:convert';

void main(List<String> args) async {
  if (args.isEmpty) {
    print('Must give a file as input');
    exit(1);
  }
  var fileName = args[0];
  var scriptDir = dirname(Platform.script.path);

  var list = await File(join(scriptDir, fileName))
      .openRead()
      .transform(utf8.decoder)
      .transform(LineSplitter())
      .toList();

  print('var data = [');
  for (var item in list) {
    var hasSingleQuote = item.contains("'");
    var hasDoubleQuote = item.contains('"');

    if (hasDoubleQuote && hasSingleQuote) {
      item = item.replaceAll("'", "\\'");
      print('    "$item",');
    } else if (hasSingleQuote) {
      print('    "$item",');
    } else {
      print("    '$item',");
    }
  }
  print('];');
}
