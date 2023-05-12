import 'dart:io';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

Future<Map<String, String>> getdji() async {
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
    "Polarity": Polarity,
    "Banefits": "Unused",
    "Evaluation": "Unused"
  };

  return mapString;
}

Future<Map<String, String>> getnk() async {
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
    "Polarity": Polarity,
    "Banefits": "Unused",
    "Evaluation": "Unused"
  };

  return mapString;
}

Future<Map<String, String>> getAny(
    String code, String holding, String price) async {
  final url = 'https://finance.yahoo.co.jp/quote/$code.T';

  final response = await http.get(Uri.parse(url));

  final body = parser.parse(response.body);

  final h1Elements = body.querySelectorAll('h1');
  final h1Texts = h1Elements.map((h1Element) => h1Element.text).toList();

  final spanElements = body.querySelectorAll('span');
  final spanTexts =
      spanElements.map((spanElement) => spanElement.text).toList();

  String Polarity = spanTexts[28][0] == '-' ? '-' : '+';

  int int_holding = int.parse(holding);

  int int_price =
      spanTexts[21] == '---' ? 0 : int.parse(spanTexts[21].replaceAll(',', ''));

  final formatter = NumberFormat('#,###');

  int banefits = int_price - int.parse(price);
  String Banefits = formatter.format(banefits); //banefits.toString();

  int evaluation = int_holding * int_price;
  String Evaluation = formatter.format(evaluation); //evaluation.toString();

  Map<String, String> mapString = {
    "Code": code,
    "Name": h1Texts[1],
    "Price": spanTexts[21],
    "Reshio": spanTexts[28],
    "Percent": spanTexts[33],
    "Polarity": Polarity,
    "Banefits": Banefits,
    "Evaluation": Evaluation
  };

  return mapString;
}

Future<Map<String, String>> getAsset(
    Map<String, String> agu, List<Map<String, String>> anyList) async {
  int intinvestment = 0;
  int intEvaluation = 0;
  final formatter = NumberFormat('#,###');

  for (var i = 2; i < agu.length; i += 3) {
    intinvestment = intinvestment +
        (int.parse(agu["key$i"]!.replaceAll(',', '')) *
            int.parse(agu["key${i + 1}"]!.replaceAll(',', '')));
  }
  String investment = formatter.format(intinvestment);

  for (int i = 0; i < anyList.length; i++) {
    intEvaluation = intEvaluation +
        int.parse(anyList[i]['Evaluation']!.replaceAll(',', ''));
  }
  String evaluation = formatter.format(intEvaluation);
  String profit = formatter.format(intEvaluation - intinvestment);
  String polarity = (intEvaluation - intinvestment) >= 0 ? "+" : "-";

  Map<String, String> mapString = {
    "Market": evaluation,
    "Invest": investment,
    "Profit": profit,
    "Polarity": polarity,
  };

  return mapString;
}

// Configure routes.
final _router = Router()
  ..get('/api/v1/user', _rootHandler)
  ..get('/api/v1/list', getStockData)
  ..get('/echo/<message>', _echoHandler)
  ..get('/api/v1/tv', getSchedule);

Future<Response> getStockData(Request req) async {
  // クエリパラメータを取得する
  final queryParameters = req.url.queryParameters;

  print(queryParameters);

//final List<String> stdcode = ['6758', '6976', '6701'];

  List<Map<String, String>> stdList = [];
  List<Map<String, String>> anyList = [];
  List<Map<String, String>> assetList = [];
  //List<Map<String, String>> assetList = [];
  String? code;
  String? holding;
  String? price;
  Map<String, String> result;

  result = await getdji();
  stdList.add(result);

  result = await getnk();
  stdList.add(result);

  for (int i = 1; i < queryParameters.length; i += 3) {
    code = queryParameters['key$i']; //anycode[i][0];
    holding = queryParameters['key${i + 1}']; //anycode[i][1];
    price = queryParameters['key${i + 2}']; //anycode[i][2];
    result = await getAny(code!, holding!, price!);
    anyList.add(result);
  }

  result = await getAsset(queryParameters, anyList);
  assetList.add(result);

  Map<String, List<Map<String, String>>> data = {
    'stdData': stdList,
    'anyData': anyList,
    'assetData':assetList
  };

  final jsonData = const JsonEncoder.withIndent("").convert(data);
  print(jsonData);
  return Response.ok(jsonData, headers: {'Content-Type': 'application/json'});
}

Future<Response> getSchedule(Request request) async {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

Future<Response> _rootHandler(Request req) async {
  List<Map<String, String>> stdstock = [];
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

  stdstock.add(jsonString);
  stdstock.add(jsonString);
  final jsonData = const JsonEncoder.withIndent("").convert(stdstock);

  print(jsonData);
  return Response.ok(jsonData, headers: {'Content-Type': 'application/json'});
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  final handler =
      const Pipeline().addMiddleware(corsHeaders()).addHandler(_router);
  // Configure a pipeline that logs requests.
  //final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '3000');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
