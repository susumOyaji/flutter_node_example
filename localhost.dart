import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf/shelf.dart';


/*
void main() async {
  var handler = const shelf.Pipeline()
      // Just add corsHeaders() middleware.
      .addMiddleware(corsHeaders())
      .addHandler(_requestHandler);

  //await serve(handler, 'localhost', 3000);
  var server = await serve(handler, 'localhost', 3000);
  print('Serving at http://${server.address.host}:${server.port}');
}

Response _requestHandler(Request request) {
  final users = [
    {'id': 1, 'message': 'Hello, world!localhost', 'name': 'User A'},
    {'id': 2, 'message': 'Hello, world!localhost', 'name': 'User B'},
    {'id': 3, 'message': 'Hello, world!localhost', 'name': 'User C'},
  ];

  // Handle GET request.
  var data = {'message': 'Hello, world!localhost'};
  var body = jsonEncode(users);
  return Response.ok(body);
  //print('Serving at http://${request.url}');
  //return Response.ok('Request for "${request.url}"');
}
*/

import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

void main() async {
  var handler = const Pipeline()
      .addMiddleware(corsHeaders())
      .addHandler(_appRouter);

  var server = await serve(handler, 'localhost', 3000);
  print('Serving at http://${server.address.host}:${server.port}');
}

Future<Response> _appRouter(Request request) {
  final app = Router();

  // Handle GET request for /.
  app.get('/', (Request request) {
    return Response.ok('Hello, world!');
  });

  // Handle GET request for /users.
  app.get('/users', (Request request) {
    final users = [
      {'id': 1, 'message': 'Hello, world!', 'name': 'User A'},
      {'id': 2, 'message': 'Hello, world!', 'name': 'User B'},
      {'id': 3, 'message': 'Hello, world!', 'name': 'User C'},
    ];

    var body = jsonEncode(users);
    return Response.ok(body, headers: {'Content-Type': 'application/json'});
  });

  // Handle POST request for /users.
  app.post('/users', (Request request) async {
    final content = await request.readAsString();
    final userData = jsonDecode(content);
    // save user data to database or something
    return Response.ok('User data received: $userData');
  });

  return app(request);
}



/*Future<void> main() async {
  final server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
  print('Listening on localhost:${server.port}');

  await for (HttpRequest request in server) {
    try {
      final response = request.response;
      response.statusCode = HttpStatus.ok;
      response.headers.contentType = ContentType.json;
      response.write(json.encode({'message': 'Hello World'}));
      print("object to localhost");
      await response.close();
    } catch (e) {
      print('Exception in handling request: $e');
    }
  }
}
*/
/*
>>>>>>> 08e18759b5b35fceb344fdf6c4fb78db22df4fa8
void main(List<String> arguments) async {
  createServer();
}

Future<HttpServer> createServer() async {
  var server = await shelf_io.serve(createRouter(), 'localhost', 3000);
  server.autoCompress = true;
  print('サーバー起動: http://${server.address.host}:${server.port}');
  return server;
}

Router createRouter() {
  final router = Router();
  router.get('/', (Request request) {
    return Response.ok("<html><body>ホットリロード対応です！</body></html>",
        headers: {"content-type": "text/html"});
  });
  router.get('/api/users', (Request request) {
    var users = [
      {'id': 1, 'name': 'ユーザーA'},
      {'id': 2, 'name': 'ユーザーB'},
      {'id': 3, 'name': 'ユーザーC'},
    ];
    var json = jsonEncode(users);
    return Response.ok(json, headers: {"content-type": "application/json"});
  });
  return router;
}

 ///  /project/lib/test.dart
//import 'dart:io';
*/
/*
void main() async {
  await httpServer();
}

Future<void> httpServer() async {
  var server = await HttpServer.bind(
    '127.0.0.1',
    3000,
  );
  await for (HttpRequest request in server) {
    try {
      final response = request.response;
      response.statusCode = HttpStatus.ok;
      response.headers.contentType = ContentType.json;
      response.write(json.encode({'message': 'Hello World'}));
      print('Exception in handling request:');
      await response.close();
    } catch (e) {
      print('Exception in handling request: $e');
    }
  }
}   
*/