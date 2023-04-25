import 'package:flutter/widgets.dart';

// myapp.dart
import 'dart:io';
//import 'dart:ui';

void maina() async {
  WidgetsFlutterBinding.ensureInitialized();
  await httpServer();
}

Future<void> httpServer() async {
  var server = await HttpServer.bind(
    '127.0.0.1',
    3000,
  );
  await for (HttpRequest request in server) {
    request.response
      ..write('Hello!')
      ..close();
  }
}

// myapp.dart

Future main() async {
  final server = await HttpServer.bind('localhost', 8080);
  print('Server started on port: ${server.port}');

  await for (HttpRequest request in server) {
    handleRequest(request);
  }
}

void handleRequest(HttpRequest request) {
  print('Received request: ${request.method} ${request.uri.path}');

  request.response
    ..headers.contentType = ContentType('text', 'plain', charset: 'utf-8')
    ..write('Hello, World!')
    ..close();
}
