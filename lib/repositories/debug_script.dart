import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

Future<void> main() async {
  final url =
      'https://tcgd.tapchigiaoduc.edu.vn/index.php/tapchi/issue/archive';
  print('Fetching $url...');
  final response = await http.get(Uri.parse(url));

  if (response.statusCode != 200) {
    print('Failed to load page: ${response.statusCode}');
    return;
  }

  var document = parser.parse(response.body);

  // 1. Check Years

  print('\n--- Checking Years ---');
  // Log all h2/h3 texts that look like years
  document.querySelectorAll('h2, h3, h4').forEach((e) {
    if (RegExp(r'\d{4}').hasMatch(e.text)) {
      print('Found header with year: "${e.text.trim()}"');
    }
  });

  // 2. Check Issues trong Page 1
  print('\n--- Checking Issues (Page 1) ---');

  var selectors = [
    'ul.issues_archive li',
    '.obj_issue_summary',
    '.issue_summary',
    'div.issue-summary',
    'li.issue_summary',
  ];

  for (var sel in selectors) {
    var els = document.querySelectorAll(sel);
    print('Selector "$sel" found ${els.length} items.');
    if (els.isNotEmpty) {
      print(
        '  First item text: "${els.first.text.trim().replaceAll(RegExp(r'\s+'), ' ').substring(0, 50)}..."',
      );
    }
  }

  // Check structure of headers
  print('\n--- checking structure of found headers ---');
  document.querySelectorAll('h2, h3, h4').forEach((e) {
    if (e.text.contains('Tập 25, số 24')) {
      print(
        'Found target text in tag <${e.localName}> with classes: "${e.className}"',
      );
      print('Parent: <${e.parent?.localName}> class: "${e.parent?.className}"');
      print(
        'GrandParent: <${e.parent?.parent?.localName}> class: "${e.parent?.parent?.className}"',
      );
    }
  });

  // 3. Pagination check
  // Kiểm tra xem có link trang tiếp theo không
  var nextLink = document.querySelector('a.next');
  if (nextLink != null) {
    print('Next page link found: ${nextLink.attributes['href']}');
  } else {
    print('No next page link found.');
  }
}
