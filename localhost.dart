import 'dart:io';


Future main() async {
 var server = await HttpServer.bind(
   InternetAddress.loopbackIPv4,
   3000,
 );
 print('Listening on localhost:${server.port}');

 await for (HttpRequest request in server) {
   request.response.write('Hello World!');
   await request.response.close();
 }
}