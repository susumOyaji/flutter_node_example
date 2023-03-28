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


  void fetch() async {
    final response = await http.get(Uri.parse('http://localhost:3000')); //^DJI
    final String json = response.body;

    setState(() {
      _responseText = json;
    });
  }

  void _opneUrl() async {
    const url = 'http://localhost:3000'; //←ここに表示させたいURLを入力する

    //if (await canLaunch(url)) {
    //  await launch(
    //    url,
    //    forceSafariVC: true,
    //    forceWebView: true,
    //  );

    //window.open(url.toString(), '_top');

    final response = await http.get(Uri.parse(url));
    print(response.body);
    setState(() {
      _responseText = response.body;
    });

    //} else {
    //  throw 'このURLにはアクセスできません';
    //}
  }

  @override
  void initState() {
    super.initState();
    //_opneUrl();
    fetch();
    //window.open('http://localhost:3000'.toString(), '_top');
  }
  //fetch();

  @override
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
              onPressed: () =>fetch(), //_opneUrl(),
            ),

            //),
            Text(_responseText),
          ],
        )));
  }
}
