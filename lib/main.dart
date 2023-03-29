import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:html';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //画面右上の赤いバーナーを消す
      debugShowCheckedModeBanner: false,
      home: UrlLaunchePage(),
    );
  }
}

class UrlLaunchePage extends StatefulWidget {
  @override
  UrlLaunchePageFul createState() => UrlLaunchePageFul();
}

class UrlLaunchePageFul extends State<UrlLaunchePage> {
  String _responseText = 'Radey';

  EdgeInsets std_margin = const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 0);

  void fetch() async {
    const url = 'http://localhost:3000'; //←ここに表示させたいURLを入力する
    final List<List<dynamic>> data = [
      ["6758", 1665, 200],
      ["6976", 300, 1801],
      ["3436", 0, 0],
    ];
    final response = await http.get(Uri.parse(url).replace(queryParameters: {
      'data': jsonEncode(data),
    }));

    //final response = await http.get(Uri.parse('http://localhost:3000')); //^DJI

    final String json = response.body;

    setState(() {
      _responseText = json;
    });
  }

  void _opneUrl() async {
    const url = 'http://localhost:3000'; //←ここに表示させたいURLを入力する
    //final params = {'id': '123', 'name': 'John Doe'};
    final params = {
      'myArray': [
        [1, 2],
        [3, 4]
      ]
    };

    final response = await http.get(Uri.http(url, '/api/data', params));
    //final url = Uri.parse('https://example.com/path?name=value');

    //final response = await http.get(url.replace(queryParameters: params));
    //final response =
    //    await http.get(Uri.parse(url).replace(queryParameters: params));

    //final response = await http.get(Uri.http(url.authority, url.path, params));
    //final response = await http.get(Uri.parse(url));
    print(response.body);
    setState(() {
      _responseText = response.body;
    });
  }

  @override
  void initState() {
    super.initState();
    //_opneUrl();
    fetch();
    //window.open('http://localhost:3000'.toString(), '_top');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Container(
          width: 500,
          height: 700,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.orange,
          ),
          child: Column(
            children: <Widget>[
              Container(
                margin: std_margin,
                width: 450,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
              ),
              Container(
                margin: std_margin,
                width: 450,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
              ),
              Container(
                margin: std_margin,
                width: 450,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
              ),
              Container(
                margin: std_margin,
                width: 450,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
              ),
              ElevatedButton(
                child: const Text('UrlOpen'),
                onPressed: () => fetch(), //_opneUrl(),
              ),

              //),
              Text(_responseText),
            ],
          ),
        ),
      ),
    );
  }

/*
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Url Launcher'),
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            //Center(
            ElevatedButton(
              child: const Text('UrlOpen'),
              onPressed: () => fetch(), //_opneUrl(),
            ),

            //),
            Text(_responseText),
          ],
        )));
  }
  */
}
