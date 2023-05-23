import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

// Configure routes.
final _router = Router()
  ..get('/', _bodyHandler)
  ..get('/root', _rootHandler)
  ..get('/echo/<message>', _echoHandler);




Future<Response> _bodyHandler(Request req) async {
  final url = req.url.toString();
  //const url = 'https://finance.yahoo.co.jp/quote/%5EDJI';
  //final response = await get(url);
  final response = await http.get(Uri.parse(url));
  return Response.ok(response.body);
}






Response _rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  //final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);
  final handler = Pipeline().addMiddleware(corsHeaders()).addHandler(_router);
  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '3000');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
 
  
}
