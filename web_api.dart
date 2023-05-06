import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

void main() async {
  final service = Service();
  final server = await shelf_io.serve(service.handler, 'localhost', 3000);
  print('Server running on localhost:${server.port}');
}

class Service {
  Handler get handler {
    final router = Router();

    // `/hello`をハンドリングする
    router.get('/api/v1/user', _helloHandler);

    return router;
  }
}

Future<Response> _helloHandler(request) async {
  List<String> stdstock = [];
  final url = Uri.parse('https://finance.yahoo.co.jp/quote/6976.T');
  final response = await http.get(url);
  final body = parser.parse(response.body);

  //final main = body.querySelectorAll('main');
  final h1Elements = body.querySelectorAll('h1');
  final h1Texts = h1Elements.map((h1Element) => h1Element.text).toList();

  final spanElements = body.querySelectorAll('span');
  final spanTexts =
      spanElements.map((spanElement) => spanElement.text).toList();

  String polarity = spanTexts[33][0] == '-' ? '-' : '+';

  Map<String, String> jsonString = {
    "Code": "6976",
    "Name": h1Texts[1],
    "Price": spanTexts[21],
    "Reshio": spanTexts[29],
    "Percent": spanTexts[33],
    "Polarity": polarity
  };

  var jsonResponse = const JsonEncoder.withIndent('  ').convert(jsonString);
  print(jsonResponse);
//print({'content-type': 'application/json'});

  return Response.ok(
    const JsonEncoder.withIndent('  ').convert(jsonString),
    headers: {'content-type': 'application/json'},
  );
}
