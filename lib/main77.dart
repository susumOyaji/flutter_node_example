import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

void main() async {
 

  // ローカルサーバーを起動
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080).then((server){
    print('Listening on localhost:${server.port}');
  });
  await Future.delayed(Duration.zero);

  runApp(MyApp());

  // アプリが終了したらサーバーも停止する
  await server.close(force: true);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _response = '';

  Future<void> _fetchData() async {
    // サーバーにリクエストを送信してレスポンスを受け取る
    final response = await http.get(Uri.parse('http://localhost:8080/data'));
    setState(() {
      _response = response.body;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Web Local Server'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _fetchData,
              child: Text('Fetch Data'),
            ),
            SizedBox(height: 20),
            Text(_response),
          ],
        ),
      ),
    );
  }
}
