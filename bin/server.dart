import 'dart:io';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/parser.dart' show parse;
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:html/parser.dart' as html;
import 'package:html/dom.dart';

Future<Map<String, String>> getdji() async {
  const url = 'https://finance.yahoo.co.jp/quote/%5EDJI';

  final response = await http.get(Uri.parse(url));

  final body = parser.parse(response.body);

  final spanElements = body.querySelectorAll('span');
  final spanTexts =
      spanElements.map((spanElement) => spanElement.text).toList();

  String polarity = spanTexts[26][0] == '-' ? '-' : '+';

  Map<String, String> mapString = {
    "Code": "^DJI",
    "Name": "^DJI",
    "Price": spanTexts[16],
    "Reshio": spanTexts[20],
    "Percent": spanTexts[26],
    "Polarity": polarity,
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

  String polarity = spanTexts[28][0] == '-' ? '-' : '+';

  Map<String, String> mapString = {
    "Code": "NIKKEI",
    "Name": "NIKKEI",
    "Price": spanTexts[16],
    "Reshio": spanTexts[20],
    "Percent": spanTexts[26],
    "Polarity": polarity,
    "Banefits": "Unused",
    "Evaluation": "Unused"
  };

  return mapString;
}

Map<String, dynamic> data2 = {
  'key1': '6758',
  'key2': '200',
  'key3': '1665',
  'key4': '6976',
  'key5': '300',
  'key6': '1801',
  'key7': '3436',
  'key8': '0',
  'key9': '0',
};

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

  String polarity = spanTexts[28][0] == '-' ? '-' : '+';

  int intHolding = int.parse(holding);

  int intPrice =
      spanTexts[21] == '---' ? 0 : int.parse(spanTexts[21].replaceAll(',', ''));

  final formatter = NumberFormat('#,###');

  int banefits = intPrice - int.parse(price);
  String Banefits = formatter.format(banefits); //banefits.toString();

  int evaluation = intHolding * intPrice;
  String Evaluation = formatter.format(evaluation); //evaluation.toString();

  Map<String, String> mapString = {
    "Code": code,
    "Name": h1Texts[1],
    "Price": spanTexts[21],
    "Reshio": spanTexts[28],
    "Percent": spanTexts[31],
    "Polarity": polarity,
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

Future<Map<String, String>> getTv() async {
  //const url = 'https://finance.yahoo.co.jp/quote/6758.T';
  const url =
      'https://www.tvkingdom.jp/schedulesBySearch.action?stationPlatformId=0&condition.keyword=HiHi&submit=%E6%A4%9C%E7%B4%A2';

  final response = await http.get(Uri.parse(url));

  final body = parser.parse(response.body);
  String htmlbody = body.outerHtml;
  //print(body.outerHtml);

  final h1Elements = body.querySelectorAll('a');
  final h1Texts = h1Elements.map((h1Element) => h1Element.text).toList();

  final spanElements = body.querySelectorAll('p');
  final spanTexts =
      spanElements.map((spanElement) => spanElement.text).toList();

  String html = '''
  <!DOCTYPE html>
  <html>
    <head>
      <meta charset="UTF-8" />
      <title>HTML Tags</title>
    </head>
    <body>
      <h1>Heading 1</h1>
      <p>Paragraph 1</p>
      <a href="#">Link 1</a>
      <h2>Heading 2</h2>
      <p>Paragraph 2</p>
      <a href="#">Link 2</a>
    </body>
  </html>
  ''';
  var document = parse(htmlbody);
  //var headings = document.getElementsByTagName('h2');

   List<Element> h1Tags = document.getElementsByTagName('h2');
   for (var h1Tag in h1Tags) {
    var siblingElements = <Element>[];
    var nextElement = h1Tag.nextElementSibling;
    
    while (nextElement != null && nextElement.localName != 'h2') {
      siblingElements.add(nextElement);
      nextElement = nextElement.nextElementSibling;
    }
    
    print('Group: ${h1Tag.text}');
    for (var element in siblingElements) {
      //print(element.outerHtml);
    }
    print('------------------------');
  }


 var h1Element = document.querySelector('h2');
  var siblingElements = <Element>[];

  var nextElement = h1Element?.nextElementSibling;
  while (nextElement != null) {
    siblingElements.add(nextElement);
    nextElement = nextElement.nextElementSibling;
  }

  print('h2: ${h1Element?.text}');
  for (var element in siblingElements) {
    print(element.outerHtml);
  }


  /*
  print('Headings:');
  for (var heading in headings) {
    print(heading.text);
  }

  var paragraphs = document.getElementsByTagName('p');
  print('Paragraphs:');
  for (var paragraph in paragraphs) {
    print(paragraph.text);
  }

  var links = document.getElementsByTagName('a');
  print('Links:');
  for (var link in links) {
    print(link.attributes['href']);
  }
  */
  //print(h1Texts);

  //String Polarity = spanTexts[28][0] == '-' ? '-' : '+';

  //int int_holding = int.parse(holding);

  //int int_price =
  //    spanTexts[21] == '---' ? 0 : int.parse(spanTexts[21].replaceAll(',', ''));

  //final formatter = NumberFormat('#,###');

  //int banefits = int_price - int.parse(price);
  //String Banefits = formatter.format(banefits); //banefits.toString();

  //int evaluation = int_holding * int_price;
  //String Evaluation = formatter.format(evaluation); //evaluation.toString();

  Map<String, String> mapString = {
    //"Code": code,
    "Name": h1Texts[42],
    "Price": spanTexts[10],
    "Reshio": spanTexts[28],
    "Percent": spanTexts[33],
    //"Polarity": Polarity,
    //"Banefits": Banefits,
    //"Evaluation": Evaluation
  };

  return mapString;
}

// Configure routes.
final _router = Router()
  ..get('/api/v1/user', _rootHandler)
  ..get('/api/v1/list', getStockData)
  ..get('/echo/<message>', _echoHandler)
  ..get('/api/v1/', getSchedule)
  ..get('/api/v1/tv', getTvSchedule);

Future<Response> getStockData(Request req) async {
  // クエリパラメータを取得する
  var queryParameters = req.url.queryParameters;

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

  Map<String, String> data2 = {
    'key1': '6758',
    'key2': '200',
    'key3': '1665',
    'key4': '6976',
    'key5': '300',
    'key6': '1801',
    'key7': '3436',
    'key8': '0',
    'key9': '0',
  };

  queryParameters = data2;

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
    'assetData': assetList
  };

  final jsonData = const JsonEncoder.withIndent("").convert(data);
  print(jsonData);
  return Response.ok(jsonData, headers: {'Content-Type': 'application/json'});
}

Future<Response> getTvSchedule(Request request) async {
  Map<String, String> result;
  List<Map<String, String>> stdList = [];

  result = await getTv();
  stdList.add(result);

  Map<String, List<Map<String, String>>> data = {
    'stdData': stdList,
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
