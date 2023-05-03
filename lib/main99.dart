import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

void main() async {
  runApp(MyApp99());
}

class MyApp99 extends StatelessWidget {
  const MyApp99({Key? key}) : super(key: key);

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
  //late Future _response;
  @override
  void initState() {
    super.initState();
    makeRequest();
    // ここで初期化処理を行う
    //runCommand();
  }

  Future<List> makeRequest() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/api/v1/list'));

      if (response.statusCode == 200) {
        // OK
        final data = json.decode(response.body);
        setState(() {
          _response = data;
          //response.body;
        });
        print(data);
        return data;
      } else if (response.statusCode == 404) {
        // Not Found
        print('404 Not Found');
        return [];
      } else {
        // エラーの場合はその他のステータスコードが返される
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

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
              onPressed: makeRequest,
              child: Text('Fetch Data'),
            ),
            SizedBox(height: 20),
            Text(_response.toString()),
          ],
        ),
      ),
    );
  }
}
