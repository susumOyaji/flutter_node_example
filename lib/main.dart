import 'dart:io';
import 'dart:convert';





void main() async {
  var server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
  print('Listening on port 8080');

  await for (HttpRequest request in server) {
    handleRequest(request);
  }
}

void handleRequest(HttpRequest request) {
  try {
    if (request.method == 'GET') {
      handleGetRequest(request);
    } else {
      request.response.statusCode = HttpStatus.methodNotAllowed;
      request.response.write('Unsupported request: ${request.method}.');
      request.response.close();
    }
  } catch (e) {
    print('Exception in handleRequest: $e');
  }
}

void handleGetRequest(HttpRequest request) {
  var path = request.uri.path;
  if (path == '/') {
    request.response.write('Hello, world!');
  } else if (path == '/greet') {
    var name = request.uri.queryParameters['name'] ?? 'Anonymous';
    request.response.write('Hello, $name!');
  } else {
    request.response.statusCode = HttpStatus.notFound;
    request.response.write('Page not found: ${request.uri.path}');
  }
  request.response.close();
}

//このコードは、8080ポートでHTTPリクエストを待ち受け、handleRequest関数を呼び出してリクエストを処理します。
//handleRequest関数は、リクエストのHTTPメソッドがGETである場合はhandleGetRequest関数を呼び出します。
//handleGetRequest関数は、URIのパスに応じて適切なレスポンスを返します。
//たとえば、ルートパス(/)に対するリクエストにはHello, world!というテキストが返され、/greetに対するリクエストには、
//nameパラメータの値に応じてHello, {name}!というテキストが返されます。

//注意：このコードは、簡単な例であり、実際のプロダクションコードで使用する場合には、セキュリティ上の問題や
//パフォーマンスの問題が存在する可能性があるため、適切に改善する必要があります










Future<void> mainm() async {


  final server = await HttpServer.bind(InternetAddressType.any, 3000);
  //final server = await HttpServer.bind(InternetAddressType.IPv6, 8080); 
  
    
    
  print('Server started on port: ${server.port}');

  await for (var request in server) {
    request.response.headers.add('Access-Control-Allow-Origin', '*');
    request.response.headers
        .add('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
    request.response.headers.add('Access-Control-Allow-Headers',
        'Origin, X-Requested-With, Content-Type, Accept');

    if (request.method == 'OPTIONS') {
      request.response.statusCode = HttpStatus.noContent;
      await request.response.close();
    } else {
      request.response.write(jsonEncode({'message': 'Hello World'}));
      await request.response.close();
    }
  }
}




void maing() async {
  final server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
  print('Listening on localhost:${server.port}');

  await for (HttpRequest request in server) {
    request.response.write('Hello, world!');
    await request.response.close();
  }
}


Future main1() async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  print('Listening on localhost:${server.port}');

  await for (final request in server) {
    request.response
      ..headers.contentType = ContentType.text
      ..write('Hello, World!');
    await request.response.close();
  }
}
