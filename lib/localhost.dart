import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_server/http_server.dart' as http;


void localget()async{
//final response = await http.get(Url pase'http://localhost:8888');

}
//final response = await http.get('http://localhost:8888');




void localhost()async  {
  final myVirtualDirectory = http.VirtualDirectory('./web')
    ..allowDirectoryListing = true;
  
  final server = await HttpServer.bind(InternetAddress('0.0.0.0'), 8080);
  
  print('Serving on http://${server.address.host}:${server.port}/');
  
  await for (HttpRequest request in server) {
    if (request.method == 'GET') {
      if (request.uri.path == '/') {
        request.response
          ..headers.contentType = ContentType.html
          ..write('Hello, World!')
          ..close();
      } else {
        myVirtualDirectory.serveRequest(request);
      }
    } else {
      request.response.statusCode = HttpStatus.methodNotAllowed;
      request.response.write('Unsupported request: ${request.method}.');
      request.response.close();
    }
  }
}



Future<void> localhost1() async {
  final server = await HttpServer.bind(
    InternetAddress.anyIPv6,8080,
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



Future<void> locasever() async {
  final server =
      await HttpServer.bind(InternetAddress.anyIPv4, 8080, shared: true);
  listenForServerResponse(server);
}

listenForServerResponse(HttpServer server) {
  server.listen((HttpRequest request) async {
    final uri = request.uri;
    request.response
      ..statusCode = 200
      ..headers.set("Content-Type", ContentType.html.mimeType);

    final code = uri.queryParameters["code"];
    final error = uri.queryParameters["error"];
    await request.response.close();
    if (code != null) {
      print(code);
    } else if (error != null) {
      print(error);
    }
  });
}