import 'dart:io';
import 'package:http/http.dart' as http;

//final response = await http.get('http://localhost:8888');

Future<void> localhost() async {
  final server = await HttpServer.bind(
    InternetAddress.anyIPv4,8080,
  );

  //var server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);


  print('Listening on localhost:${server.port}');

  await for (HttpRequest request in server) {
    handleRequest(request);
  }
}

void handleRequest(HttpRequest request) async {
  if (request.method == 'GET' && request.uri.path == '/hello') {
    request.response
      ..write('Hello, world!')
      ..close();
  } else {
    request.response
      ..write('Not found')
      ..close();
  }
}
