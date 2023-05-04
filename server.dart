import 'dart:io';
import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

Future<Map<String, String>> getdji() async {
  //const dom = await JSDOM.fromURL('https://finance.yahoo.co.jp/quote/998407.O');
  const url = 'https://finance.yahoo.co.jp/quote/%5EDJI';

  final response = await http.get(Uri.parse(url));

  final body = parser.parse(response.body);

  final spanElements = body.querySelectorAll('span');
  final spanTexts =
      spanElements.map((spanElement) => spanElement.text).toList();

  String Polarity = spanTexts[26][0] == '-' ? '-' : '+';

  Map<String, String> mapString = {
    "Code": "^DJI",
    "Name": "^DJI",
    "Price": spanTexts[16],
    "Reshio": spanTexts[20],
    "Percent": spanTexts[26],
    "Polarity": Polarity
  };

  return mapString;
}

Future<Map<String, String>> getnk() async {
  //const dom = await JSDOM.fromURL('https://finance.yahoo.co.jp/quote/998407.O');
  const url = 'https://finance.yahoo.co.jp/quote/998407.O';

  final response = await http.get(Uri.parse(url));

  final body = parser.parse(response.body);

  final spanElements = body.querySelectorAll('span');
  final spanTexts =
      spanElements.map((spanElement) => spanElement.text).toList();

  String Polarity = spanTexts[28][0] == '-' ? '-' : '+';

  Map<String, String> mapString = {
    "Code": "NIKKEI",
    "Name": "NIKKEI",
    "Price": spanTexts[18],
    "Reshio": spanTexts[22],
    "Percent": spanTexts[28],
    "Polarity": Polarity
  };

  return mapString;
}

Future<Map<String, String>> getAny(String code) async {
  //final String baseUrl = 'https://finance.yahoo.co.jp/quote/';
  final url = 'https://finance.yahoo.co.jp/quote/$code.T';

  final response = await http.get(Uri.parse(url));

  final body = parser.parse(response.body);

  final h1Elements = body.querySelectorAll('h1');
  final h1Texts = h1Elements.map((h1Element) => h1Element.text).toList();

  final spanElements = body.querySelectorAll('span');
  final spanTexts =
      spanElements.map((spanElement) => spanElement.text).toList();

  String Polarity = spanTexts[28][0] == '-' ? '-' : '+';

  Map<String, String> mapString = {
    "Code": code,
    "Name": h1Texts[1],
    "Price": spanTexts[21],
    "Reshio": spanTexts[29],
    "Percent": spanTexts[33],
    "Polarity": Polarity
  };

  return mapString;
}

// Configure routes.
final _router = Router()
  ..get('/api/v1/user', _rootHandler)
  ..get('/api/v1/list', getStockData)
  ..get('/echo/<message>', _echoHandler);

Future<Response> getStockData(Request req) async {
  final List<String> stdcode = ['6758', '6976', '6701'];
  final List<Map<String, String>> stdstock = [];
  Map<String, String> result;

  result = await getdji();
  stdstock.add(result);

  result = await getnk();
  stdstock.add(result);

  for (int i = 0; i < stdcode.length; i++) {
    final String code = stdcode[i];
    result = await getAny(code);
    stdstock.add(result);
  }

  final jsonResponse = jsonEncode(stdstock);
  print(jsonResponse);

  //return Response.ok(jsonResponse,
  //    headers: {'Content-Type': 'application/json'});
  return Response.ok("oooookkkk");
}

Future<Response> _rootHandler(Request req) async {
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

  String Polarity = spanTexts[33][0] == '-' ? '-' : '+';

  List<Map<String, dynamic>> jsonString = [
    {
      "Code": "6758",
      "Name": "${h1Texts[1]}",
      "Price": "${spanTexts[21]}",
      "Reshio": "${spanTexts[29]}",
      "Percent": "${spanTexts[33]}",
      "Polarity": "$Polarity"
    }
  ];
  final jsonData = jsonEncode(jsonString);
  stdstock.add(jsonData);

  print(jsonData);
  return Response.ok(jsonData, headers: {'Content-Type': 'application/json'});
  //return Response.ok(jsonData);

  //return Response.ok('Hello, World!\n');
}

/*
Response _rootcode(HttpRequest request) {
  // リスト形式の株式データ
  List<Map<String, dynamic>> stocks = [
    {'Code': '1234', 'Name': 'Apple Inc.', 'Price': 100.0},
    {'Code': '5678', 'Name': 'Microsoft Corporation', 'Price': 200.0},
    {'Code': '9012', 'Name': 'Amazon.com, Inc.', 'Price': 300.0},
  ];

  // JSON形式に変換してレスポンスを返す
  request.response.statusCode = 200;
  request.response.headers.set('Content-Type', 'application/json');
  request.response.write(jsonEncode(stocks));
  request.response.close();
}
*/
Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '3000');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
